#!/usr/bin/python3
import socket
import sys 
try:
    target = input("Type your target ip: ")
    if not target.strip(): 
        print("Target can not be empty!")
        exit()
    ports_info = input("Ports: ")
    if not ports_info.strip():
        print("Ports can not be empty!")
        exit()
    if ports_info.lower() == "all":
        ports = list(range(1,65536))
    else:
        ports = ports_info.split(",")
        num = 0
        for port in ports:
            ports[num] = int(port)
            num += 1
    print(f"Scanning your {target}...")
    for port in ports:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            s.connect((target, port))
            print(f"Port {port} is open!")
        except:
            pass 
        finally:
            s.close()
except KeyboardInterrupt:
    print("User Interrupted!")
    sys.exit()
