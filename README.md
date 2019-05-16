# TestHorde

Shows an issue with Horde.Registry losing all it's values when another node
joins.


## How to replicate

1. Start first node: `./start_node_1`

```elixir
+cbrodt@cbrodt-traitify ~/tmp/test_horde (master): ./start_node_1
Erlang/OTP 21 [erts-10.3.4] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]


08:55:38.874 [info]  Starting Horde.RegistryImpl with name TestHorde.Registry

08:55:38.882 [info]  Starting Horde.SupervisorImpl with name TestHorde.Supervisor
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_0"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_1"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_2"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_3"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_4"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_5"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_6"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_7"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_8"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_9"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_10"}}]
Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(test-horde-1@127.0.0.1)1> Horde.Registry.processes(TestHorde.Registry)
warning: Horde.Registry.processes/1 is deprecated. It be removed in a future version
  iex:1

%{
  "TestGenServer_0" => {#PID<0.201.0>, nil},
  "TestGenServer_1" => {#PID<0.202.0>, nil},
  "TestGenServer_10" => {#PID<0.211.0>, nil},
  "TestGenServer_2" => {#PID<0.203.0>, nil},
  "TestGenServer_3" => {#PID<0.204.0>, nil},
  "TestGenServer_4" => {#PID<0.205.0>, nil},
  "TestGenServer_5" => {#PID<0.206.0>, nil},
  "TestGenServer_6" => {#PID<0.207.0>, nil},
  "TestGenServer_7" => {#PID<0.208.0>, nil},
  "TestGenServer_8" => {#PID<0.209.0>, nil},
  "TestGenServer_9" => {#PID<0.210.0>, nil}
}
iex(test-horde-1@127.0.0.1)2>
```

2. Start the second node: `./start_node_2`

```elixir

cbrodt@cbrodt-traitify ~/tmp/test_horde (master): ./start_node_2
Erlang/OTP 21 [erts-10.3.4] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]


09:05:47.068 [info]  Starting Horde.RegistryImpl with name TestHorde.Registry

09:05:47.084 [info]  Starting Horde.SupervisorImpl with name TestHorde.Supervisor
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_0"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_1"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_2"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_3"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_4"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_5"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_6"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_7"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_8"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_9"}}]
TestGenServer args: [name: {:via, Horde.Registry, {TestHorde.Registry, "TestGenServer_10"}}]
Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)

09:05:47.256 [debug] Received :nodeup message from :"test-horde-1@127.0.0.1"

09:05:47.256 [debug] Received :nodeup message from :"test-horde-1@127.0.0.1"
iex(test-horde-2@127.0.0.1)1> Horde.Registry.processes(TestHorde.Registry)
warning: Horde.Registry.processes/1 is deprecated. It be removed in a future version
  iex:1

%{}
iex(test-horde-2@127.0.0.1)2>
```

3. Further testing indicated that if you stopped the second node, the first node
   would re-register all the process names, but that the second node joining
   would always remove all the Registry entries.


## Expectations

My expectation is that no matter what order nodes join in, that registry entries
would be preserved.

