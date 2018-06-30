# Plexus
Shell script to install a [Plexus Masternode](https://plexuscoin.org/) V2.0.4 on a Linux server running Ubuntu 16.04. Use it at your own risk.

***
## Installation:
After you setup the VPS at your chosen provider, you will need to login as root to the server and execute the following commands. You can copy and paste the commands into the command line. For instructions for using SSH to login to your server, please see your hosting providers documentation. 
```
wget -q https://raw.githubusercontent.com/PlexusCoin/Plexus-MN-guide/master/PlexusMN_install.sh
bash PlexusMN_install.sh
```
When the setup script completes it will prompt you for the Private Key for your masternode. Please reference step 6 below for the Private Key you will need during this step. 

Upon completion, use the commands at the end of this document to be sure yourserver is running properly. 
***

## Desktop wallet setup

After the MN is up and running, you need to configure the desktop wallet accordingly. Here are the steps for Windows Wallet
1. Open the **Plexus Desktop Wallet**.
2. Go to RECEIVE and create a New Address: **MN1**. After the screen pops up, choose the Copy Address button. 
3. Then go to the Send tab and in the Address field, paste in the address you just copied from the step above and send exactly **10000** **Plexus** to **MN1**.
4. Go to transactions and and you will see the send you just did to yourself. By double clicking the transaction, you can see how many confirmations there are. Wait for 15 confirmations to complete before continuing with the steps below.
5. Go to **Tools -> "Debug console - Console"**
6. Type the following command: **masternode genkey** - this will generate the Private Key(privkey in masternode.conf file referenced below)
7. Type the following command: **masternode outputs** - this will show you the transaction ID and the Output Index (TXHash and Output_index in the masternode.conf file referenced below)
8. Go to  **Tools -> "Open Masternode Configuration File"** 
9. Add the following entry(there is an example entry at the top of the file for guidance):
```
Alias Address Privkey TxHash Output_index
```
* Alias: **MN1**
* Address: **VPS_IP:PORT**
* Privkey: **Masternode Private Key** - from step 6 above
* TxHash: **First value from Step 6**
* Output index:  **Second value from Step 6**
10. Save and close the file.
11. Go to **Masternode Tab**. If you tab is not shown, please enable it from: **Settings - Options - Wallet - Show Masternodes Tab**
12. Click **Update status** to see your node. If it is not shown, close the wallet and start it again.
13. Open **Debug Console** and type:
```
 masternode start-missing "MN1"
```
You can also issue the Start Missing command from the Masternode tab by highlighting your masternode with a click on the line and then clicking the Start Missing button at the bottom of the screen. 
***

## Server commands:
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


