# HBOM — Hardware Bill of Materials

## Free Tools

| Tool | Install | Purpose |
|------|---------|---------|
| [lshw](https://ezix.org/project/wiki/HardwareLiSter) | `apt install lshw` / `brew install lshw` | Detailed hardware lister for Linux/macOS |
| [dmidecode](https://www.nongnu.org/dmidecode/) | `apt install dmidecode` | Decode BIOS/UEFI hardware component info |
| [inxi](https://github.com/smxi/inxi) | `apt install inxi` | Full system information reporting |
| [fwupd](https://github.com/fwupd/fwupd) | `apt install fwupd` | Firmware update daemon + device inventory |
| [CycloneDX cdxgen](https://github.com/CycloneDX/cdxgen) | `npm install -g @cyclonedx/cdxgen` | Hardware component inventory via CycloneDX spec |
| [OCSInventory](https://github.com/OCSInventory-NG/OCSInventory-ocsreports) | Docker image | Hardware & software inventory server |
| [OpenBMC](https://github.com/openbmc/openbmc) | Build from source | Open-source BMC firmware with hardware inventory |
| [Netdata](https://github.com/netdata/netdata) | `bash <(curl -Ss ...get.netdata.cloud)` | Real-time hardware metrics & inventory |

## Quick Examples

```bash
# Full hardware inventory with lshw (JSON format)
sudo lshw -json > hbom-lshw.json

# BIOS/UEFI component information
sudo dmidecode --type system > hbom-system.txt
sudo dmidecode --type bios   > hbom-bios.txt
sudo dmidecode --type memory > hbom-memory.txt

# Compact system summary
inxi -F -xxx -a --output json > hbom-inxi.json

# List firmware devices and update status
fwupdmgr get-devices --json > hbom-firmware.json

# Check available firmware updates
fwupdmgr get-updates
```

## Example HBOM Output (CycloneDX)

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.6",
  "components": [
    {
      "type": "device",
      "name": "Dell PowerEdge R750",
      "manufacturer": "Dell Technologies",
      "version": "1.0",
      "components": [
        {
          "type": "firmware",
          "name": "BIOS",
          "version": "2.14.0",
          "supplier": { "name": "Dell" }
        },
        {
          "type": "hardware",
          "name": "Intel Xeon Gold 6338",
          "version": "rev 01",
          "supplier": { "name": "Intel" }
        }
      ]
    }
  ]
}
```

## Standards & Compliance

- IEC 62443 (OT/ICS Security)
- NIST SP 800-82 (ICS Security Guide)
- NERC CIP (Critical Infrastructure Protection)
- FIPS 140-3 (hardware crypto modules)
