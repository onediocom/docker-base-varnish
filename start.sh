#! /bin/sh

varnishd -F -f $VARNISH_VCL -s malloc,$VARNISH_CACHE
