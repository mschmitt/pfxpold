pfxpold - Postfix extensible policy daemon
------------------------------------------

The Postfix Extensible Policy Daemon, pfxpold, aims to provide a flexible
framework for policy delegation in the context of the Postfix MTA. It is
written in Perl and accepts policy check routines in the form of Perl modules.

+----------+
|          | sender=foo +---------+-------------+    
| Postfix  |----------->|         |             |     {File, DNS, SOAP,     }
|          |            | pfxpold | PFXCheck.pm |---> {LDAP, SQL, ... (every}
|  smtpd   |<-----------|         |             |     {conceivable Protocol)}
|          |  Action=OK +---------+-------------+
+----------+

APPLICATIONS

pfxpold is especially suited for environments where relay access control for
diverse automated mailers, such as application servers, scan-to-mail devices or
bulk mailers, is required.

In this capacity, pfxpold is production quality software that has done smtpd
access rule checking for many millions of e-mails since the deployment of its
first task-specific predecessor in 2005.

THE IMPLEMENTATION

pfxpold is a stand-alone daemon that is accessed by Postfix through the
standard policy delegation interface. 

See http:www.postfix.org/SMTPD_POLICY_README.html from the Postfix docs for
details on how Postfix communicates with the policy service and how to
integrate the policy service into your Postfix environment.

Implemented as a forking daemon using TCP sockets, pfxpold has proven to very
robust. On the other hand, this might just be due to the extremely good manners
of its only client application, the Postfix MTA.

Unprivileged (non-root) operation is the default. Chroot operation is
implemented, but might not be suitable for every kind of plugin.

The download contains the pfxpold daemon script itself, along with sample check
plugins in the form of Perl modules.

pfxpold was developed on Linux using Perl 5.8.x and is known to work on Solaris
8 using Perl 5.6.1.

pfxpold requires the Perl module Unix::Syslog as its only non-standard
dependency. You may also need database (DBI/DBD) or LDAP modules for your own
implementation of a check plugin.

pfxpold is not ready to run, but will always require development of a custom
check plugin in simple object oriented Perl. The default plugin shipping with
the distribution randomly accepts and denies requests.

GETTING STARTED

Unpack the ZIP file to an appropriate location (such as /opt/pfxpold/) and run:

  NOFORK=1 DEBUG=1 ./pfxpold

Then, in another terminal, test the functionality:

  $ nc localhost 9998
  sender=foo@example.com
  client_address=1.2.3.4
  client_name=foo.bar

  action=OK (you win!)


SUPPORT

Support is available through the pfxpold help forum on Sourceforge. Commercial
support (especially for the creation of custom check plugins) can be made
available.

HISTORY

pfxpold is derived from a custom policy service that was developed by the
original author for one of his clients. This client had a complex SMTP
permission ruleset that would have taken excessive work to fit into a
maintainable Postfix restriction class schema.

Only a short while later, the author was approached by another client who was
looking for the exact same solution, checking against a different backend.
Thus, the checking logic was torn out of the base policy service and a
modularized pfxpold was created.
