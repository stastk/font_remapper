#use strict;
#use warnings;
use LWP::UserAgent;
use Data::Dumper;

my $ua = new LWP::UserAgent;
$ua->agent("AgentName/0.1 " . $ua->agent);
$t = 'sadasd\'\'\'asds__-___####33adasdsdfdas\'';
my $req = new HTTP::Request GET => "http://localhost:9292/remap_do?t=${t}";
my $res = $ua->request($req);

print Dumper($res->content);