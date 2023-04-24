
# think of an actual real world example 

# investigate querying jsonb/maps in ecto
- what are the use cases for querying? (id, timestamp)

# implement event struct + sequence
- add sequence checking to events
- test race conditions
    - ie sequence missmatches
    - aggregates do not persist if sequences conflict

# cross aggregate boundaries


# code gen
- is there a way to automatically generate the migrations for this?
- is this worth while?