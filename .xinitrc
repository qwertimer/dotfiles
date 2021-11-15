#!/bin/sh

exec xmonad
autocutsel -fork -selection CLIPBOARD
autocutsel -fork -selection PRIMARY
