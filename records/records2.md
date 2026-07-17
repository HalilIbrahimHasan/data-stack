Subject

Best Life (83502) Reconciliation – Manual Investigation Findings

Hi Hari,

Following today's working session, I completed the initial manual investigation and identified several reconciliation patterns. Rather than a single root cause, the records initially classified as missing fall into multiple categories.

Key Findings

1. A significant portion of the initially missing population was found in Azure.

During the manual investigation, many of the enrollee IDs initially classified as missing were located in Azure under different issuers and, in several cases, different coverage years.

This confirms that these records are not missing from Azure altogether. However, these cross-issuer matches should not be interpreted as proof that the corresponding Best Life (HIOS 83502) Dental enrollment was loaded, since the same individual may have enrollment records under multiple carriers.

Examples identified during manual validation include records found under issuers such as 49046, 70893, 37001, and 45334, as well as records found under coverage year 2025 when the business report expected 2026.

The attached workbook contains the supporting issuer and coverage-year matches identified during this investigation.

2. Workbench resolves some member searches through the subscriber policy.

We observed that searching certain dependent member IDs in the Georgia Access Workbench does not return the dependent directly. Instead, the Workbench resolves the search to the subscriber's policy and household.

Example:

Searched Member ID: 1007765191
Workbench Policy ID: 1000219154
Subscriber: 1007765200

The household displayed:

Subscriber: 1007765200
Spouse: 1007765191
Child: 1007765201
Child: 1007765202
Child: 1007765203

In Azure, the subscriber and several household members exist, while the searched dependent member ID is currently not represented. This indicates that some reconciliation differences may occur at the dependent-member level rather than at the policy or subscriber level.

3. Additional household-level observations

We also identified cases where:

the policy exists,
part of the household exists,
but one or more dependent member IDs are currently not found in Azure.

Example:

Policy ID: 211838771
Azure issuer: 49046
Member found: 1002168067
Member currently not found: 1006457453

Again, this confirms that the person exists in Azure, but not necessarily under the expected issuer or household representation.

4. Remaining unresolved population

After classifying records into the patterns above, a smaller unresolved population remains.

Examples include:

Policy ID: 1000204311
Member IDs:
1000659343
1001741286
1000659344

and

Policy ID: 210955684
Member IDs:
1000659343
1001741286
1000659344

These records could not currently be located in Azure and represent the highest-priority candidates for the next phase of investigation.

For these remaining records, we plan to validate:

Account History file name
inbound_automation_file_log
Source XML
Household member inventory
Policy-level reconciliation
Attachments
Issuer and Coverage Year Investigation
Records located under different issuers and/or different coverage years.
Supporting XML Examples
XML samples demonstrating cross-issuer examples identified during the manual investigation.

The manual investigation significantly reduced the initially unexplained population by classifying many records into identifiable reconciliation patterns. 
The remaining unresolved records will now be investigated through source-file and file-log validation.

Thanks,

Selma
