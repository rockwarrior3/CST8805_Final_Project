
import re
import subprocess as sp

serverAddress = "https://www.heistless.com/server/"

TLSv0 = sp.getoutput(f"curl -I -v -k --tlsv1 --tls-max 1.0 {serverAddress} ")
TLSv1 = sp.getoutput(f"curl -I -v -k --tlsv1.1 --tls-max 1.1 {serverAddress}")
TLSv2 = sp.getoutput(f"curl -I -v -k --tlsv1.2 --tls-max 1.2 {serverAddress}")
TLSv3 = sp.getoutput(f"curl -I -v -k --tlsv1.3 --tls-max 1.3 {serverAddress}")

array = [TLSv0, TLSv1, TLSv2, TLSv3]
for i in array:
	try:
		found = re.search(r"error.*", i).group(0)
		if found:
			print(found)
	except:
		try:
			success = re.search(r"SSL connection using.*", i).group(0)
			if success:
				print(success)
		except:
			print('¯\\_(ツ)_/¯')
