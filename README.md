# Plexus
Shell script to install a [Plexus Masternode](https://plexuscoin.com/) V2.0.2 on a Linux server running Ubuntu 16.04. Use it on your own risk.

***
## Installation:
```
wget -q https://raw.githubusercontent.com/altcuim/Plexus-MN-guide/master/plexus_install.sh
bash plexus_install.sh
```
***

## Desktop wallet setup

After the MN is up and running, you need to configure the desktop wallet accordingly. Here are the steps for Windows Wallet
1. Open the **Plexus Desktop Wallet**.
2. Go to RECEIVE and create a New Address: **MN1**
3. Send **10000** **Plexus** to **MN1**.
4. Wait for 15 confirmations.
5. Go to **Tools -> "Debug console - Console"**
6. Type the following command: **masternode outputs**
7. Go to  **Tools -> "Open Masternode Configuration File"**
8. Add the following entry:
```
Alias Address Privkey TxHash Output_index
```
* Alias: **MN1**
* Address: **VPS_IP:PORT**
* Privkey: **Masternode Private Key**
* TxHash: **First value from Step 6**
* Output index:  **Second value from Step 6**
9. Save and close the file.
10. Go to **Masternode Tab**. If you tab is not shown, please enable it from: **Settings - Options - Wallet - Show Masternodes Tab**
11. Click **Update status** to see your node. If it is not shown, close the wallet and start it again. Make sure the wallet is un
12. Open **Debug Console** and type:
```
 masternode start-missing "MN1"
```
***

## Usage:
```
plexus-cli mnsync status
plexus-cli getinfo
plexus-cli masternode status #This command will show your masternode status
```

Also, if you want to check/start/stop **plexus** , run one of the following commands as **root**:

```
systemctl status Plexus #To check the service is running.
systemctl start Plexus #To start plexus service.
systemctl stop Plexus #To stop plexus service.
systemctl is-enabled Plexus #To check whetether plexus service is enabled on boot or not.
```
***

## Donations:  

Any donation is highly appreciated.  


