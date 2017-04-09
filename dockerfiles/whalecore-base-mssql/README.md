# Base-MSSQL

Base Images for all containers running Microsoft SQL Server.

## Environment Variables

For more information, check the original README: <https://github.com/Microsoft/mssql-docker/tree/master/windows/mssql-server-windows-express>

### sa_password

Sets the password of the sa account and enabled the login. It has a minimum complexity requirement (8 characters, uppercase, lowercase, alphanumerical and/or non-alphanumerical).

### accept_eula

Set this to `Y` otherwise nothing will work.

### attach_dbs

The configuration for attaching custom DBs (.mdf, .ldf files).

This should be a JSON string, in the following format (note the use of SINGLE quotes!)

```JSON
[
    {
        'dbName': 'MaxDb',
        'dbFiles': ['C:\\temp\\maxtest.mdf',
        'C:\\temp\\maxtest_log.ldf']
    },
    {
        'dbName': 'PerryDb',
        'dbFiles': ['C:\\temp\\perrytest.mdf',
        'C:\\temp\\perrytest_log.ldf']
    }
]
```