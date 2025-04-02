import os
import subprocess
import re
import sys

def query_yes_no(question, default="yes"):
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
        choice = input().lower()
        if default != None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            return False

def global_replace(find, replace):
    try:
        command = f'ag -l \"{find}\"'
        needs_changes = subprocess.check_output(command, shell=True).decode().split("\n")

        if not query_yes_no("Replace all instances of \"%s\" with \"%s\"? (%d files affected)" % (find, replace, len(needs_changes) - 1), "no"):
            return

        print("Processing:")
        for file in needs_changes[:-1]:
            command = "perl -0777 -i -pe 's/" + find + "/" + replace + "/g' " + file
            print("%s" % file)
            os.system(command)
    except subprocess.CalledProcessError as e:
        print("(%s)" % e)
    except Exception as e:
        print("Error:", e)
        return

if len(sys.argv) != 3:
    print("Usage: global_replace $find $replace")
else: 
    global_replace(sys.argv[1], sys.argv[2])
