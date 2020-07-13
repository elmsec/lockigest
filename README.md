# 🔐 Lockigest
Lockigest is a very primitive, manipulative security software that sets a trap instead of locking your device screen immediately to protect it from strangers.

### Read more:
- English: https://elma.pw/notes/lockigest/
- Turkish: https://elma.pw/tr/notes/lockigest/

## Configuration
These two lines of code are enough to set up your Lockigest:
```bash
...
wait_time=120
countdown=5
...
```

The first one is the time, in seconds, that must pass before starting protection mode (setting a trap).  

The second variable is a countdown that will be trigged when protection mode is activated. Locks the screen when it reaches zero. If the user moves the cursor to the predefined area, this countdown stops and disables the protection mode. 
