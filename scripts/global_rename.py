import os
import subprocess
import re
import sys
import glob

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
        choice = input().lower()
        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            return False

def global_rename(find, replace, ffilter="*"):
    try:
        files = glob.glob("**/%s" % ffilter, recursive=True)
        needs_rename= list(filter(lambda x : find in x, files))

        if (len(needs_rename) is 0):
            print("No files found containing name \"%s\"" % find)
            return

        print("Found:")
        print(needs_rename)        
        if not query_yes_no("Rename all instances of \"%s\" with \"%s\"? (%d files affected)" % (find, replace, len(needs_rename)), "no"):
            return
    
        print("Processing:")
        for file in needs_rename:
            new_file = file.replace(find, replace)
            print("%s -> %s" % (file, new_file))
            os.rename(file, new_file)
    except subprocess.CalledProcessError as e:
        print("Not a git repo. [TODO] Run with --nogit to search without a git cache (SLOW).")
        print("(%s)" % e)
    except:
        return

if len(sys.argv) < 3:
    print("Usage: global_replace $find $replace [$file_filter]")
else: 
    if (len(sys.argv) is 4):
        ffilter = sys.argv[3]
    else:
        ffilter = "*"
    global_rename(sys.argv[1], sys.argv[2], ffilter)
