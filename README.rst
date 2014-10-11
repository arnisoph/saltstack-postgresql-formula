============================
saltstack-postgresql-formula
============================

.. image:: https://api.flattr.com/button/flattr-badge-large.png
    :target: https://flattr.com/submit/auto?user_id=bechtoldt&url=https%3A%2F%2Fgithub.com%2Fbechtoldt%2Fsaltstack-postgresql-formula

Salt Stack Formula to set up and configure PostgreSQL, an object-relational database system

NOTICE BEFORE YOU USE
=====================

* This formula aims to follow the conventions and recommendations described at http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#conventions-formula and http://docs.saltstack.com/en/latest/topics/best_practices.html

TODO
====

* configure/ initialize clusters

Instructions
============

1. Add this repository as a `GitFS <http://docs.saltstack.com/topics/tutorials/gitfs.html>`_ backend in your Salt master config.

2. Configure your Pillar top file (``/srv/pillar/top.sls``) and your pillars, see pillar.example.sls

3. Include this Formula within another Formula or simply define your needed states within the Salt top file (``/srv/salt/top.sls``).

Available states
================

.. contents::
    :local:

``postgresql.client``
---------------------
Install PostgreSQL client libraries

``postgresql.server``
---------------------
Setup and configure PostgreSQL server

Additional resources
====================

None

Templates
=========

Some states/ commands may refer to templates which aren't included in the files folder (``postgresql/files``). Take a look at ``contrib/`` (if present) for e.g. template examples and place them in separate file roots (e.g. Git repository, refer to `GitFS <http://docs.saltstack.com/topics/tutorials/gitfs.html>`_) in your Salt master config.

Formula Dependencies
====================

None

Contributions
=============

Contributions are always welcome. All development guidelines you have to know are

* write clean code (proper YAML+Jinja syntax, no trailing whitespaces, no empty lines with whitespaces, LF only)
* set sane default settings
* test your code
* update README.rst doc

Salt Compatibility
==================

Tested with:

* 2014.1.x

OS Compatibility
================

Tested with:

* GNU/ Linux Debian Wheezy
