import os.path
import subprocess
home = os.path.expanduser("~")
def mailpasswd(acct):
  acct = os.path.basename(acct)
  path = "%s/.local/share/misc/%s.gpg" % (home,acct)
  args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", path]
  try:
    return subprocess.check_output(args).strip().decode('UTF-8')
  except subprocess.CalledProcessError:
      return ""
