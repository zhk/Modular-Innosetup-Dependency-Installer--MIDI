; requires Windows 8, 8.1, 10 or Windows Server 2012, Server 2012 R2
; requires Microsoft .NET Framework 3.5 SP 1 or later
; requires Windows Installer 4.5 or later
; SQL Server Express is supported on x64 and EMT64 systems in Windows On Windows (WOW). SQL Server Express is not supported on IA64 systems
; SQLEXPR32.EXE is a smaller package that can be used to install SQL Server Express on 32-bit operating systems only. The larger SQLEXPR.EXE package supports installing onto both 32-bit and 64-bit (WOW install) operating systems. There is no other difference between these packages.
; https://www.microsoft.com/en-us/server-cloud/MIDI_Products/sql-server-2016/

[CustomMessages]
sql2016express_title=Microsoft SQL Server 2016 Express (32 bit)
sql2016express_title_x64=Microsoft SQL Server 2016 Express (64 bit)

en.sql2016express_url=
en.sql2016express_url_x64=
de.sql2016express_url=
de.sql2016express_url_x64=
fr.sql2016express_url=
fr.sql2016express_url_x64=
fi.sql2016express_url=
fi.sql2016express_url_x64=
sp.sql2016express_url=
sp.sql2016express_url_x64=
nl.sql2016express_url=
nl.sql2016express_url_x64=
it.sql2016express_url=
it.sql2016express_url_x64=
pl.sql2016express_url=
pl.sql2016express_url_x64=
ru.sql2016express_url=
ru.sql2016express_url_x64=

[Components]
; You must duplicate size of each component because ExtraDiskSpaceRequired flag cannot use variable 
Name: "dependencies\ms_sql2016express"; Description: {cm:sql2016express_title}; ExtraDiskSpaceRequired: 0; Types: custom; Check: not Is64BitInstallMode;
Name: "dependencies\ms_sql2016express"; Description: {cm:sql2016express_title_x64}; ExtraDiskSpaceRequired: 0; Types: custom; Check: Is64BitInstallMode;

[Code]
const
	sql2016sp1express_size=1.0;
	sql2016sp1express_size_x64=1.0;
	
/// <summary>
/// Install dependency
/// </summary>
/// <returns>True if successful, False otherwise.</returns>
function sql2016express() : Boolean;
var
	version: string;
	versionToCheck : string;
	applicationSetupName : string;
begin
	Result := True;
	versionToCheck := IntToStr(SqlServer2016_MajorVersion) + '.0';

	// Store application filename
	applicationSetupName := 'SQLEXPR' + MIDI_GetArchitectureStringEx() + '_' + CustomMessage('MIDI_SqlLanguage') + '.exe';;

	if (not MIDI_IsIA64()) then begin
		// Check if the full version fo the SQL Server 2016 is installed
		RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Microsoft SQL Server\SQLSERVER\MSSQLServer\CurrentVersion', 'CurrentVersion', version);
		if (version < versionToCheck) or (version = '') then begin
			// If the full version is not found then check for the Express edition
			RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Microsoft SQL Server\SQLEXPRESS\MSSQLServer\CurrentVersion', 'CurrentVersion', version);
			if (MIDI_CompareVersion(version, versionToCheck) < 0) then begin
				// Add product to list
				MIDI_AddProduct(applicationSetupName,
				'/QS /ACTION=Install /IAcceptSQLServerLicenseTerms /FEATURES=SQL,AS,RS,IS,Tools /INSTANCENAME=SQLEXPRESS /SQLSVCACCOUNT="NT AUTHORITY\Network Service" /SQLSYSADMINACCOUNTS="builtin\administrators"',
				CustomMessage('sql2016express_title' + MIDI_GetArchitectureString()),
				MIDI_GetSizeString (sql2016express_size, sql2016express_size_x64, 00),
				MIDI_GetString(CustomMessage('sql2016express_url'), CustomMessage('sql2016express_url_x64'), ''),
				false, false);
			end else begin
				// Express version of SQL Server 2016 already installed.
				MIDI_AddInstalledProduct(applicationSetupName,
					CustomMessage('sql2016express_title' + MIDI_GetArchitectureString()),
					MIDI_GetSizeString (sql2016express_size, sql2016express_size_x64, 00),
					MIDI_GetString(CustomMessage('sql2016express_url'), CustomMessage('sql2016express_url_x64'), ''),
					false, false);
			end;
		end else begin
			Log ('[MIDI] Full version of SQL Server 2016 already installed.');
		end;
	end else begin
		Log ('[MIDI] IA64 architeture not supported.');
	end;
end;


// Leave the [Code] Section
[Tasks]
; Leave the [Code] Section