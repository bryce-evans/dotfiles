import os
import subprocess
import re
import sys

def query_yes_no(question, default="yes"):
    """Ask a yes/no question via raw_input() and return their answer.

    "question" is a string that is presented to the user.
    "default" is the presumed answer if the user just hits <Enter>.
        It must be "yes" (the default), "no" or None (meaning
        an answer is required of the user).

    The "answer" return value is True for "yes" or False for "no".
    """
    valid = {"yes": True, "y": True, "ye": True,
             "no": False, "n": False}
    if default is None:
        prompt = " [y/n] "
    elif default == "yes":
        prompt = " [Y/n] "
    elif default == "no":
        prompt = " [y/N] "
    else:
        raise ValueError("invalid default answer: '%s'" % default)

    while True:
        sys.stdout.write(question + prompt)
        choice = raw_input().lower()
        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            return False

def global_replace(find, replace):
    try:
        find_short = find.split("\\n")[0]
        command = "git grep --untracked -l -E '" + find_short + "'";
        #print(command)
        needs_changes = subprocess.check_output(command, shell=True).split("\n")
        
        if not query_yes_no("Replace all instances of \"%s\" with \"%s\"? (%d files affected)" % (find, replace, len(needs_changes) - 1), "no"):
            return
    
        # Trim the empty last element in the return output of grep.
        print("Processing:")
        for file in needs_changes[:-1]:
            command = "perl -0777 -i -pe 's/" + find + "/" + replace + "/g' " + file
            #print("Executing: " + command)
            print("%s" % file)
            os.system(command)
    except subprocess.CalledProcessError as e:
        print("Not a git repo. [TODO] Run with --nogit to search without a git cache (SLOW).")
        print("(%s)" % e)
    except Exception as e:
        print("Error:", e)
        return

if len(sys.argv) is not 3:
    print("Usage: global_replace $find $replace")
else: 
    global_replace(sys.argv[1], sys.argv[2])
