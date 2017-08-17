#!/bin/bash

autossh -L2222:localhost:22 -N nkoster@devhomes &
disown
