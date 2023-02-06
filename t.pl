print "Hello World!\n";

use LWP::UserAgent;
use Data::Dumper;

my $ua = new LWP::UserAgent;
$ua->agent("AgentName/0.1 " . $ua->agent);
#my $req = new HTTP::Request POST => 'http://localhost:9292/remap_do';
$t = 'sadasd\'\'\'asds__-___####33adasdsdfdas\'';
#print "${t}";
#my $req = new HTTP::Request GET => "http://stas.tk/?t=$self->{'t'}";
my $req = new HTTP::Request GET => "http://localhost:9292/remap_do?t=${t}";
#$req->content('t=sadasdasdasd');
my $res = $ua->request($req);

print Dumper($res->content);