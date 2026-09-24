#  Secure Windows File System Over Local Access Network

Unpatched **SMB services** (ports `139` and `445`), **Samba File Sharing** and **default remote administration** settings allow attackers on the same network to scan, discover, and potentially execute remote code on vulnerable Windows machines. 

The given script automates essential security controls by restricting inbound network connections, disabling file-sharing services, and shutting down unnecessary administrative endpoints.

---

## How it works

* **Inbound Firewall Restriction:** Enforces a strict **Block Inbound / Allow Outbound** firewall policy across every network profiles.
* **Stealth Mode (Anti-Reconnaissance):** Disables **Network Discovery** rules, making the system secure on local network scanner.
* **SMB Vulnerability Mitigation:** Disables **File and Printer Sharing** rules and disables the `LanmanServer` (Server) service to **close ports 139 and 445** against exploit tools like **Metasploits**. This service allows the attacker to perform attacks on the victims computer through Local Wifi Network.
* **Remote Access Securing:** Disables **WinRM** (Windows Remote Management) and the **RemoteRegistry** service to prevent lateral movement and unauthorized registry manipulation on the computer.

---

### How to Run

1. Clone or download `secure.bat` from this repository.
2. Right-click `secure.bat` and select **Run as administrator**.
3. Verify output:
   * **`Done`**: Successfully worked the file.
   * **`Please run it as administrator.`**: re-run with admin permisions.

---

## Some things u should note before using this file.

* **Local Sharing:** Disabling `LanmanServer` and `File and Printer Sharing` will prevent other devices on the local Wi-Fi/Ethernet network from accessing shared folders or printers on your PC.
* **Remote Admin:** Disabling `WinRM` and `RemoteRegistry` stops remote administrative tools (like PowerShell Remoting) from managing this machine over the network.


will write more about this sooonnnnn.
