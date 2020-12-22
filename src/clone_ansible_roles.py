#!/usr/bin/env python3
"""Clone ansible roles and collections.

This script will parse ansible-galaxy requirements files at the root of git
repos and clone roles and collections which have a 'src' key defining git repos
URL.

Other roles which do not have `src` key, will be added to a temporary
requirements files which will then be used normally with the ansible-galaxy
command.

Attributes:
    SCRIPT_DIR: Absolute path to the directory where this script is
    COLORS: Dictionary holding string allowing to color print text
"""

# PYLINT ======================================================================
# Globally deactivate pylint exception for this file.
# pylint: disable=R0903
#   - R0903: Too few public methods (0/2) (too-few-public-methods)

# LIBRARY IMPORT ==============================================================

# Miscellaneous operating system interfaces
# https://docs.python.org/3/library/os.html
import os

# GitPython is a python library used to interact with Git repositories
# https://pypi.org/project/GitPython/
import git

# YAML parser and emitter for Python
# https://pypi.org/project/PyYAML/
import yaml

# CONSTANT VARIABLES ==========================================================
# Directory where this script is
SCRIPT_DIR: str = os.path.dirname(os.path.abspath(__file__))
# Set of strings allowing to color print text
COLORS: dict = dict(
    BLUE="\033[94m",
    GREEN="\033[92m",
    YELLOW="\033[93m",
    RED="\033[91m",
    END_COLORS="\033[0m",
    BOLD="\033[1m",
    UNDERLINE="\033[4m",
)


# FUNCTIONS ===================================================================
def write_yaml(data: dict, output_file: str) -> None:
    """Write content of `data` into `output_file` in a yaml format.

    Arguments:
        data: Dictionary which hold data to write.
        output_file: Path to the output file to which `data` will be written.
    """
    with open(output_file, "w") as stream:
        try:
            yaml.dump(data, stream)
        except yaml.YAMLError as exc:
            print(exc)


def load_yaml(input_file: str) -> dict:
    """Load content of yaml `into_file` into a dictionary.

    Arguments:
        input_file: Path to the input file to load.

    """
    with open(input_file, "r") as stream:
        try:
            output_dict = yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)
    return output_dict


def get_git_root(path: str) -> str:
    """Return the root path of the git repo from a path given as arguments.

    Arguments:
        path: Path from which to find the git root path

    Return:
        Git root path
    """
    git_repo = git.Repo(path, search_parent_directories=True)
    return git_repo.git.rev_parse("--show-toplevel")


# CLASSES ===================================================================
class CloneRoles:
    """Class handling cloning of ansible roles and collections.

    Class responsible for download ansible roles and collections either using
    `git` or `ansible-galaxy` depending on the `requirements.yaml` content.

    Attributes:
      REQUIREMENT_FILENAME: String storing default requirements.yaml
      REQUIREMENT_FILENAME_TEMP: String storing temporary requirements.yaml
    """

    REQUIREMENT_FILENAME: str = "requirements.yaml"
    REQUIREMENT_FILENAME_TEMP: str = "requirements.temp.yaml"

    # Initialistion
    # -------------------------------------------------------------------------
    def __init__(self) -> None:
        """Initialisation method."""
        self.requirement_ansible_galaxy_temp = dict(roles=[], collections=[])
        self.requirement_ansible_galaxy = dict()
        self.delete_temp_file = True

    # Properties
    # -------------------------------------------------------------------------
    @property
    def requirement_ansible_galaxy(self) -> dict:
        """Dictionary storing `ansible-galaxy` requirements."""
        return self._requirement_ansible_galaxy

    @property
    def requirement_ansible_galaxy_temp(self) -> dict:
        """Dictionary storing temporary `ansible-galaxy` requirements.

        Dictionary storing temporary ansible galaxy requirement that can not be
        cloned using git and will be downloaded normally.
        """
        return self._requirement_ansible_galaxy_temp

    @property
    def delete_temp_file(self) -> bool:
        """Boolean to track installation types.

        Boolean to know if installation of requirement with `ansible-galaxy`
        default value went right (True) or wrong(False).
        """
        return self._delete_temp_file

    # Getters
    # -------------------------------------------------------------------------
    @requirement_ansible_galaxy.setter
    def requirement_ansible_galaxy(self, value: dict) -> None:
        """Setter of the variable `requirement_ansible_galaxy`."""
        self._requirement_ansible_galaxy = value

    @requirement_ansible_galaxy_temp.setter
    def requirement_ansible_galaxy_temp(self, value: dict) -> None:
        """Setter of the variable `requirement_ansible_galaxy_temp`."""
        self._requirement_ansible_galaxy_temp = value

    @delete_temp_file.setter
    def delete_temp_file(self, value: bool) -> None:
        """Setter of the variable `delete_temp_file`."""
        self._delete_temp_file = value

    # Deleters
    # -------------------------------------------------------------------------
    @requirement_ansible_galaxy.deleter
    def requirement_ansible_galaxy(self) -> None:
        """Deleter of the variable `requirement_ansible_galaxy`."""
        del self._requirement_ansible_galaxy

    @requirement_ansible_galaxy_temp.deleter
    def requirement_ansible_galaxy_temp(self) -> None:
        """Deleter of the variable `requirement_ansible_galaxy_temp`."""
        del self._requirement_ansible_galaxy_temp

    @delete_temp_file.deleter
    def delete_temp_file(self) -> None:
        """Deleter of the variable `delete_temp_file`."""
        del self._delete_temp_file

    # Static Methods
    # -------------------------------------------------------------------------
    @staticmethod
    def _clone_ansible_item(item: dict, repo_dir: str) -> None:
        """Clone role or collection with git.

        Clone ansible role or collection which have a source starting with
        `git+`.

        Arguments:
            item: Dictionary of ansible role or collection
            repo_dir: Path where the role will be cloned
        """
        git_url = item["src"].split("+")[1]
        print(
            COLORS["GREEN"]
            + "[INFO] Cloning role "
            + item["name"]
            + COLORS["END_COLORS"]
        )
        git.Repo.clone_from(git_url, repo_dir)

    # Private method
    # -------------------------------------------------------------------------
    def _process_ansible_item(self, key: str, item: dict) -> bool:
        """Determin how to handle role or collection.

        Determine if role or collection should be cloned or downloaded using
        ansible-galaxy default behaviour.

        Arguments:
            item: Dictionary holding the ansible role or collection
            key: String defining if item is a role or a collection
        """
        item_path = os.path.join(
            os.getenv("ANSIBLE_" + key.upper() + "_PATH"), item["name"]
        )
        if not os.path.isdir(item_path):
            if "src" in item and item["src"].startswith("git+"):
                self._clone_ansible_item(item, item_path)
            else:
                self.requirement_ansible_galaxy_temp[key] += [item]
            return False
        return True

    def _process_default_ansible_item(
        self, key: str, requirement_file: str
    ) -> None:
        """Call `ansible-galaxy` for specific entry.

        Call the command `ansible-galaxy` for the `key` provided using the
        temporary requirement file provided by `requirement_file`.

        Arguments:
            key: Key in dictionary defined in file `requirement_file`
            requirement_file: >-
                Path to the temporary `ansible-galaxy` tempoarary
                requirements file.
        """
        if self.requirement_ansible_galaxy_temp[key]:
            print(
                COLORS["GREEN"]
                + "[INFO] Installing "
                + key
                + " from temporary requirement using ansible-galaxy default"
                + COLORS["END_COLORS"]
            )
            cmd = (
                "ansible-galaxy " + key[:-1] + " install -r " + requirement_file
            )
            # If return code is not 0
            if os.system(cmd):
                self.delete_temp_file = False

    def _process_default_ansible_requirements(self, git_root_dir: str) -> None:
        """Process roles and collections with `ansible-galaxy`.

        Process the temporary generated ansible roles and collections that will
        be install using command `ansible-galaxy` with default behaviour.

        Arguments:
            git_root_dir: Path to the root directory of the git repo.
        """
        print(
            COLORS["GREEN"]
            + "[INFO] Writing temporary ansible-galaxy requirement"
            + COLORS["END_COLORS"]
        )
        write_yaml(
            self.requirement_ansible_galaxy_temp,
            os.path.join(git_root_dir, self.REQUIREMENT_FILENAME_TEMP),
        )
        for i_key in self.requirement_ansible_galaxy_temp:
            self._process_default_ansible_item(
                i_key,
                os.path.join(git_root_dir, self.REQUIREMENT_FILENAME_TEMP),
            )

        if self.delete_temp_file:
            print(
                COLORS["GREEN"]
                + "[INFO] Everything went right. Deleting temporary files"
                + COLORS["END_COLORS"]
            )
            os.remove(
                os.path.join(git_root_dir, self.REQUIREMENT_FILENAME_TEMP)
            )
        else:
            print(
                COLORS["YELLOW"]
                + "[WARNING] Something went wrong when running ansible-galaxy\n"
                + "[WARNING] with temporary ansible requirement files: \n"
                + "[WARNING]   - "
                + os.path.join(git_root_dir, self.REQUIREMENT_FILENAME_TEMP)
                + "\n"
                + "[WARNING] Files will not be deleted."
                + COLORS["END_COLORS"]
            )

    # Public method
    # -------------------------------------------------------------------------
    def process(self) -> None:
        """Process the `ansible-galaxy` requirements.

        Main computation method which will process the `ansible-galaxy`
        requirements file at the root of a git repo.
        """
        nothing_to_do_msg = True
        git_root_dir = get_git_root(SCRIPT_DIR)
        self.requirement_ansible_galaxy = load_yaml(
            os.path.join(git_root_dir, self.REQUIREMENT_FILENAME)
        )
        for i_key in self.requirement_ansible_galaxy:
            for i_item in self.requirement_ansible_galaxy[i_key]:
                if not self._process_ansible_item(i_key, i_item):
                    nothing_to_do_msg = False
        # Install roles that does not have 'src' key defining git repo using
        # ansible-galaxy default command.
        if self.requirement_ansible_galaxy:
            self._process_default_ansible_requirements(git_root_dir)

        if nothing_to_do_msg:
            print(
                COLORS["GREEN"]
                + "[INFO] Nothing to do, roles are already installed."
                + COLORS["END_COLORS"]
            )


def main() -> None:
    """Main method.

    Main method, simply create a CloneRoles object and run CloneRoles.process().
    """
    clone_roles = CloneRoles()
    clone_roles.process()


if __name__ == "__main__":
    main()
