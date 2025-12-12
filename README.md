<p align="center">
    <img src="" alt="FastNetScan">
</p>

<table align="center">
  <tr>
    <td align="center">
      <a href="https://apache.org/licenses/LICENSE-2.0.txt">
        <img src="https://img.shields.io/badge/License-Apache%202.0-green.svg" alt="License">
      </a>
    </td>
    <td align="center">
      <img src="https://img.shields.io/badge/Version-v1.0.0-blue" alt="Version">
    </td>
    <td align="center">
      <img src="https://img.shields.io/badge/Arch-ALL-green?style=flat&labelColor=gray" alt="Arch: ALL">
    </td>
    <td align="center">
      <img src="https://img.shields.io/badge/Author-rompelhd-red" alt="Author">
    </td>
  </tr>
</table>

<p align="center">
    <i>Remember to use this script in a controlled environment.</i>
    <i>I am not responsible for any incidents. You are solely responsible.</i>
</p>

<br/>

<p align="center">
    <b>FastNetScan</b> is a high-speed Bash-based network scanner developed to identify active hosts in large IP ranges using parallel execution and the power of <code>fping</code>.
</p>

<br/>

## 🚀 How FastNetScan Works

FastNetScan dramatically accelerates host discovery by combining:

- **fping** for low-overhead ICMP reachability tests  
- **Parallel execution** via <code>xargs -P</code>  
- **Dynamic IP generation** using wildcard patterns  
- **Progress tracking** with a live counter  
- **Automatic results logging** into <code>online_hosts.txt</code>

<br/>

## ⭐ Key Features

- Supports wildcard IP ranges like:
  - `10.0.0.*`
  - `192.168.*.*`
  - `10.0.*.1`
- Ultra-fast parallel scanning using multiple CPU cores  
- Real-time progress indicator  
- Writes all active hosts to `online_hosts.txt`  
- Clean exit and safe temp file handling  
- Works on any Linux system with **bash** and **fping** installed  

<br/>

## 🧪 Usage

To scan a subnet:

```bash
fastnetscan 192.168.1.*
```
<br/>

## 📦 Installation

To install FastNetScan system-wide, simply run:


```bash
curl -fsSL https://raw.githubusercontent.com/rompelhd/FastNetScan/refs/heads/main/src/install.sh | bash
```
