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
