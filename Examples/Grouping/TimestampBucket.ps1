$data = ConvertFrom-Csv @"
Timestamp,Tenant
10/29/2018 3:00:00.123,1
10/29/2018 3:00:10.456,1
10/29/2018 3:01:20.389,1
10/29/2018 3:00:30.222,1
10/29/2018 3:00:40.143,1
10/29/2018 3:00:50.809,1
10/29/2018 3:01:00.193,1
10/29/2018 3:01:10.555,1
10/29/2018 3:01:20.739,1
10/29/2018 3:01:30.912,1
10/29/2018 3:01:40.989,1
10/29/2018 3:01:50.545,1
10/29/2018 3:02:00.999,1
"@ | Select-Object @{n = 'Timestamp'; e = {get-date $_.timestamp}}, tenant, @{n = 'Bucket'; e = { - (get-date $_.timestamp).Second % 30}}

$f = "$env:temp\pivottest.xlsx"
Remove-Item $f -ErrorAction SilentlyContinue

$pivotDefParams = @{
    PivotTableName = 'Timestamp Buckets'
    PivotRows      = @('Timestamp', 'Tenant')
    PivotData      = @{'Bucket' = 'count'}
    GroupDateRow   = 'TimeStamp'
    GroupDatePart  = @('Hours', 'Minutes')
    Activate       = $true
}

$excelParams = @{
    PivotTableDefinition = New-PivotTableDefinition @pivotDefParams
    Path                 = $f
    WorkSheetname        = "Log Data"
    AutoSize             = $true
    AutoFilter           = $true
    Show                 = $true
}

$data | Export-Excel @excelParams