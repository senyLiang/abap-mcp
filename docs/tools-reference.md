# ABAP MCP Tools Reference

Complete reference for all 120 tools available in the abap-mcp server.

## Session Management

| Tool | Description |
|------|-------------|
| `CreateSession` | Create editing session for stateful operations (lock/save/activate) |
| `ListSessions` | List all active sessions |
| `DestroySession` | Destroy session and release resources |

## Object Reading

### Classes & Interfaces

| Tool | Description |
|------|-------------|
| `GetClass` | Get class main source code |
| `GetClassInclude` | Get local include (definitions/implementations/macros/testClasses) |
| `GetInterface` | Get interface source code |

### CDS & RAP

| Tool | Description |
|------|-------------|
| `GetCDSView` | Get CDS view / DDL source code |
| `GetBehaviorDefinition` | Get RAP behavior definition source |
| `GetServiceDefinition` | Get service definition source |
| `GetServiceBinding` | Get service binding metadata |
| `GetBopfBusinessObject` | Get BOPF BO metadata (nodes, actions, associations) |

### Programs & Includes

| Tool | Description |
|------|-------------|
| `GetProgram` | Get program (report) source code |
| `GetInclude` | Get include program source |
| `GetFunctionGroup` | Get function group source |
| `GetFunctionModule` | Get function module source |

### Dictionary Objects

| Tool | Description |
|------|-------------|
| `GetTable` | Get table definition |
| `GetTableFields` | Get table field details (types, lengths, keys) |
| `GetStructure` | Get structure definition |
| `GetStructureFields` | Get structure component details |
| `GetDataElement` | Get data element definition |
| `GetDomain` | Get domain definition |

### SAP Object Types

| Tool | Description |
|------|-------------|
| `GetSAPObjectType` | Get SAP Object Type (RONT) source |
| `GetSAPObjectNodeType` | Get SAP Object Node Type (NONT) source |

### Other

| Tool | Description |
|------|-------------|
| `GetObjectStatus` | Check activation status (active/inactive) |
| `GetObjectDocumentation` | Get SE61 docs, message texts, keyword help |
| `GetPackageContents` | List objects in a package |

## Object Creation

| Tool | Description |
|------|-------------|
| `CreateClass` | Create new ABAP class |
| `CreateInterface` | Create new interface |
| `CreateProgram` | Create new program |
| `CreateInclude` | Create new include |
| `CreateFunctionGroup` | Create new function group |
| `CreateDDLSource` | Create new CDS view / DDL source |
| `CreateBehaviorDefinition` | Create RAP behavior definition |
| `CreateServiceDefinition` | Create service definition |
| `CreateServiceBinding` | Create service binding |
| `CreateMetadataExtension` | Create DDLX metadata extension |
| `CreateAccessControl` | Create DCL access control |
| `CreateTable` | Create dictionary table |
| `CreateStructure` | Create structure |
| `CreateDataElement` | Create data element |
| `CreateDomain` | Create domain |
| `CreateSAPObjectType` | Create SAP Object Type (RONT) |
| `CreateSAPObjectNodeType` | Create SAP Object Node Type (NONT) |

## Object Saving

| Tool | Description |
|------|-------------|
| `SaveClass` | Save class main source (auto lock/unlock) |
| `SaveClassInclude` | Save local include (definitions/implementations/macros) |
| `SaveClassTestInclude` | Save test classes include |
| `SaveInterface` | Save interface source |
| `SaveProgram` | Save program source |
| `SaveInclude` | Save include source |
| `SaveFunctionGroup` | Save function group source |
| `SaveFunctionModule` | Save function module source |
| `SaveDDLSource` | Save CDS view source |
| `SaveBehaviorDefinition` | Save behavior definition |
| `SaveServiceDefinition` | Save service definition |
| `SaveMetadataExtension` | Save DDLX source |
| `SaveAccessControl` | Save DCL source |
| `SaveTable` | Save table DDL source |
| `SaveStructure` | Save structure DDL source |
| `SaveDataElement` | Save data element source |
| `SaveDomain` | Save domain source |
| `SaveSAPObjectType` | Save SAP Object Type source |
| `SaveSAPObjectNodeType` | Save SAP Object Node Type source |

## Object Deletion

| Tool | Description |
|------|-------------|
| `DeleteClass` | Delete class (irreversible) |
| `DeleteInterface` | Delete interface |
| `DeleteProgram` | Delete program |
| `DeleteInclude` | Delete include |
| `DeleteFunctionGroup` | Delete function group |
| `DeleteCDSView` | Delete CDS view |
| `DeleteBehaviorDefinition` | Delete behavior definition |
| `DeleteServiceDefinition` | Delete service definition |
| `DeleteServiceBinding` | Delete service binding |
| `DeleteMetadataExtension` | Delete metadata extension |
| `DeleteAccessControl` | Delete access control |
| `DeleteStructure` | Delete structure |
| `DeleteDataElement` | Delete data element |
| `DeleteDomain` | Delete domain |

## Activation & Syntax

| Tool | Description |
|------|-------------|
| `ActivateObject` | Activate saved object (make active version) |
| `CheckSyntax` | Syntax check without activation |
| `LockObject` | Manually lock for editing |
| `UnlockObject` | Manually release lock |

## Search & Analysis

| Tool | Description |
|------|-------------|
| `Search` | Search repository by name/pattern (wildcards: *) |
| `GetWhereUsed` | Find all usages of an object (whole-object or position-based) |
| `GetUsageSnippets` | Get source code snippets for where-used results |

## Data Access

| Tool | Description |
|------|-------------|
| `PreviewTableData` | Preview DDIC table/view data (columnar XML) |
| `PreviewCDSView` | Preview CDS view data (supports parameters) |
| `SelectSQLQuery` | Execute read-only Open SQL SELECT queries |

## Testing & Quality

| Tool | Description |
|------|-------------|
| `RunAbapUnit` | Run ABAP Unit tests (with optional coverage) |
| `GetCoverageResult` | Get coverage summary from unit test run |
| `GetStatementCoverage` | Get line-level coverage (executed/not executed) |
| `RunATC` | Run ATC static analysis checks |
| `GetATCFindings` | Retrieve ATC findings by worklist ID |
| `GetATCResult` | Drill into persistent ATC results |
| `GetATCFindingDocumentation` | Get HTML docs for specific ATC finding |
| `ListATCCheckVariants` | List available ATC check variants |
| `ListATCResults` | Browse historical ATC results |

## Debugging

| Tool | Description |
|------|-------------|
| `DebugStartSession` | Start debug session (set BP + trigger + attach) |
| `DebugSetBreakpoint` | Add breakpoint during active session |
| `DebugDeleteBreakpoint` | Remove breakpoint and listener |
| `DebugWaitForBreakpoint` | Wait for external trigger to hit BP |
| `DebugGetStack` | Get call stack at current position |
| `DebugGetVariables` | Inspect variables (@ROOT, @LOCALS, or specific) |
| `DebugSetVariable` | Modify variable value during debugging |
| `DebugStep` | Step over / into / return |
| `DebugStepToLine` | Run to specific line or jump |
| `DebugResume` | Continue execution |

## Version Management

| Tool | Description |
|------|-------------|
| `GetVersionHistory` | List all versions with author/date/transport |
| `GetVersionContent` | Get source of a specific version |
| `CompareVersions` | Unified diff between two versions |

## Transport Requests

| Tool | Description |
|------|-------------|
| `ListTransportRequests` | List transports (filter by user/status) |
| `GetTransportRequests` | Get available transports for an object |
| `GetTransportContents` | List objects in a transport |

## Runtime Errors

| Tool | Description |
|------|-------------|
| `ListRuntimeErrors` | List ST22 dumps (filter by user/time) |
| `GetRuntimeError` | Get full dump details |

## System Configuration

| Tool | Description |
|------|-------------|
| `ListSystems` | List all configured SAP systems |
| `AddSystem` | Add new SAP system (SNC auth) |
| `UpdateSystem` | Modify system configuration |
| `RemoveSystem` | Remove a system |
| `GetLandscapeSystems` | Read systems from SAP GUI landscape file |

## Utilities

| Tool | Description |
|------|-------------|
| `FormatADTResponse` | Convert raw ADT XML to human-readable text |
| `GetDiscovery` | Get ADT endpoint capabilities |

## Common Workflows

### Read → Modify → Activate

```
1. CreateSession
2. GetClass (read current source)
3. SaveClass (with session_id, auto lock/save/unlock)
4. ActivateObject (syntax check + activate)
5. DestroySession
```

### Search → Analyze

```
1. Search (find objects by pattern)
2. GetWhereUsed (find dependencies)
3. GetUsageSnippets (get code context)
```

### Test → Debug

```
1. RunAbapUnit (run tests, get coverage)
2. GetCoverageResult (coverage summary)
3. DebugStartSession (if test fails, debug)
4. DebugGetVariables / DebugStep (investigate)
```

### ATC Quality Check

```
1. RunATC (static analysis)
2. GetATCFindings (retrieve findings)
3. GetATCFindingDocumentation (understand finding)
```
