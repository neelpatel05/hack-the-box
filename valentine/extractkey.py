file = open("hype_key","r")
lines = file.readlines()
data = lines[0]
data = data.split(" ")
data = ''.join(data)
print(data)
