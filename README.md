# EPAgent Plug-in for CA Service Desk

# Description
The EPAgent Plug-in monitors CA Service Desk web engine statistics.

The agent creates these metrics for each web engine:
* Cumulative sessions so far
* Most sessions at a time
* Currently active sessions

For installation instructions, see the README.md file.

# Short Description
The EPAgent Plug-in monitors CA Service Desk web engine statistics.

# Dependencies
Tested with CA APM 9.7.1 EM, EPAgent 9.7.1, and Perl 5.22.

# Licensing
Apache License, version 2.0. See [Licensing](https://www.apache.org/licenses/LICENSE-2.0).

# Installation

1. Install and configure the EPAgent.
Find the version 9.1 to 9.5 documentation on [CA Support](https://support.ca.com) and the version 9.6 to 10.x documentation on [the CA APM wiki at docops.ca.com](https://docops.ca.com/display/APMDEVOPS).
2. Install the EPAgent Plug-in: create a directory \<epa_Home\>/epaplugins/casd and copy the perl script casd.pl into that directory.
3. Add a stateless plug-in entry in the configuration file \<epa_Home\>/IntroscopeEPAgent.properties:
Note: CASD is a CA APM abbreviation for CA Service Desk. Use ``CASD`` where shown.

```
	introscope.epagent.plugins.stateless.names=CASD (can be appended to a previous entry)
	introscope.epagent.stateless.CASD.command=perl <epa_home>/epaplugins/casd/casd.pl <casdInstallDir>
	introscope.epagent.stateless.CASD.delayInSeconds=900
```

# Usage
Start the EPAgent using the control script in the \<epa_home\>/bin directory.

# Debugging
You can update the root logger in \<epa_home\>/IntroscopeEPAgent.properties from INFO to DEBUG, then save. No managed application restart needed.
You can also manually execute the plug-in from a console and use the PERL built-in debugger.

# Limitations
* The default configuration does not pull the active sessions. The EPAgent Plug-in can be altered to gathered this information if needed.
* Be sure that the data is sent back as a StringEvent because in the output there is no relevant data attached to this line.

* **For Windows users only:**
We *highly* recommended that you do *not* use spaces in the CA Service Desk installation directory path.
Instead, use ``dir /x`` from a command prompt to view your directory names in 8.3 format.

# Support
This document and extension are made available from CA Technologies. They are provided as examples at no charge as a courtesy to the CA APM Community at large. This extension might require modification for use in your environment. However, this extension is not supported by CA Technologies, and inclusion in this site should not be construed to be an endorsement or recommendation by CA Technologies. This extension is not covered by the CA Technologies software license agreement and there is no explicit or implied warranty from CA Technologies. The extension can be used and distributed freely amongst the CA APM Community, but not sold. As such, it is unsupported software, provided as is without warranty of any kind, express or implied, including but not limited to warranties of merchantability and fitness for a particular purpose. CA Technologies does not warrant that this resource will meet your requirements or that the operation of the resource will be uninterrupted or error free or that any defects will be corrected. The use of this extension implies that you understand and agree to the terms listed herein.
Although this extension is unsupported, please let us know if you have any problems or questions. You can add comments to the CA CA APM Community site so that the author(s) can attempt to address the issue or question.
Unless explicitly stated otherwise this extension is only supported on the same platforms as the CA APM Java agent.

# Support URL
https://github.com/CA-APM/ca-apm-fieldpack-epa-casd/issues

# Product Compatibilty Matrix
http://pcm.ca.com/

# Categories
Integration Packaged Applications

# Change Log
Changes for each extension version.

Version | Author | Comment
--------|--------|--------
1.0 | Hiko Davis | First version of the extensions.
