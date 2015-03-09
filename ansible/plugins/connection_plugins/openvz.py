import os
import subprocess
import time

from ansible import errors
from ansible.callbacks import vvv

class Connection(object):
   def list_containers(self):
      p = subprocess.Popen(['/usr/sbin/vzlist','-H','-o','hostname'],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
      stdout,stderr = p.communicate()
      return stdout.split()

   def get_ctid(self):
      p = subprocess.Popen(['/usr/sbin/vzlist','-H','-o','ctid','-h',self.host],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
      stdout,stderr = p.communicate()
      return stdout.lstrip().rstrip()

   def __init__(self,runner,host,port,*args,**kwargs):
      self.host = host
      self.runner = runner
      self.has_pipelining = False
      if os.geteuid() != 0:
         raise errors.AnsibleError("openvz connection requires running as root")

      if not self.host in self.list_containers():
         raise errors.AnsibleError("No such container: %s" % self.host)

      self.ctid = self.get_ctid()
      vvv("CTID: " + self.ctid, host=self.host)
      pass

   def connect(self, port=None):
      return self

   def exec_command(self,cmd,tmp_path,sudo_user=None,sudoable=False,executable='/bin/sh',in_data=None,su=None,su_user=None):
      if in_data:
         raise errors.AnsibleError("Internal Error: this module does not support optimized module pipelining.")
      if executable:
         local_cmd = ['/usr/sbin/vzctl','exec',self.ctid,executable,'-c','"',cmd,'"']
      else:
         local_cmd = ['/usr/sbin/vzctl','exec',self.ctid,cmd]

      vvv("EXECUTABLE %s" % (executable), host=self.host)
      vvv("EXEC %s" % (local_cmd), host=self.host)
      p = subprocess.Popen(local_cmd,shell=isinstance(local_cmd,basestring),stdout=subprocess.PIPE,stderr=subprocess.PIPE)
      stdout,stderr = p.communicate()
      return(p.returncode,'',stdout,stderr)

   def put_file(self, in_path, out_path):
      local_cmd = ['/usr/sbin/vzctl','exec',self.ctid,'/bin/sh','-c','"','cat > %s' % format(out_path),'"']
      vvv("PUT CMD %s" % (local_cmd), host=self.host)
      vvv("PUT %s %s" % (in_path,out_path), host=self.host)
      p = subprocess.Popen(local_cmd, stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
      p.stdin.write(open(in_path).read())
      p.stdin.close()
      time.sleep(1)
      p.terminate()

   def fetch_file(self, in_path, out_path):
      pass

   def close(self):
      pass

