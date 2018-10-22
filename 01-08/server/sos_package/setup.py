#!/usr/bin/env python

from distutils.core import setup

setup(name='sosreport',
      version='0.2',
      description=("""A set of tools to gather troubleshooting"""
                   """ information from a system."""),
      author='None',
      author_email='None',
      url='None',
      license="GPLv2+",
      scripts=['sosreport'],
      packages=['sos', 'sos.plugins', 'sos.policies'],
      requires=['six', 'futures'],
      data_files=[('/etc', ['sosreport.conf'])]
      )

# vim: set et ts=4 sw=4 :
