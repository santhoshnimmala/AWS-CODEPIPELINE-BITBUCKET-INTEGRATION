import os
import subprocess

cwd = os.getcwd()  # Get the current working directory (cwd)
files = os.listdir(cwd)  # Get all the files in that directory
print("Files in %r: %s" % (cwd, files))
# Using readlines()
file1 = open('sample.txt','r')
Lines = file1.readlines()
a = [] 
# Strips the newline character
for line in Lines:
    d = {}
    d["key"]=line.rstrip('\n').split("=")[0]
    d["value"]= line.rstrip('\n').split("=")[1]
    a.append(d)
print(a)
cmd = "aws servicecatalog provision-product --product-id prod-fhg67bjrz2lfq --provisioned-product-name 'mytestppname3' --provisioning-parameters {}".format(a)
c=subprocess.call(cmd, shell=True)


