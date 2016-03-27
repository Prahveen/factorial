%% Meta data about the application
{application, factorial_system, [
  {description, "Factorial Calculation System - Testing Erlang OTP"},
  {vsn, "2"},
  {modules,[factorial_client, factorial_logic, factorial_server,factorial_supervisor, factorial_system,database_server, database_logic]},
  {registered, [factorial_server,database_server]},
  {applications, [kernel,stdlib,mnesia]},
  {mod, {factorial_system, []}}, %% Entry point  to the application
  {env, []}
]}.