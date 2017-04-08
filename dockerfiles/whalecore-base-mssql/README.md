# Base-MSSQL

Base Images for all containers running Microsoft SQL Server.

## Environment Variables

### whalecore_local_admin_create

`true` or `false` - Defines if a local admin should be created. This is required if you want to use remote iis management.
Default: `false`

### whalecore_local_admin_username

Name of the local windows account used as admin if `whalecore_local_admin_create` is enabled
Default: `whalecore_admin`

### whalecore_local_admin_password

Password of the local windows account used as admin if `whalecore_local_admin_create` is enabled
Default: `-#w@l3s&B4c0n!-`