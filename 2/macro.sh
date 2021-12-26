#!/bin/sh

macro() {
	MACRO=$(pwd)
}

polo() {
	cd "$MACRO" || exit
}
