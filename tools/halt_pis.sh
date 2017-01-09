#!/bin/sh

ansible pis -i ../hosts --become --args "/sbin/halt" --forks 4 --user pi
