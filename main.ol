include "console.iol"
include "string_utils.iol"


type events: void {
    .event:string
}

interface getEvents {
RequestResponse:
    ListRepoEvents( void )( undefined )
}

outputPort EventsPort {
	Location:
        "socket://api.github.com:443/repos/mvillumsen/ProgrammingAssignment2/"	
    Protocol: https {
        .osc.ListRepoEvents.alias = "events";
        .method = "get";
        .addHeader.header[0] = "User-Agent";
        .addHeader.header[0].value = "Blah";
        .ssl.protocol = "TLSv1.2";
        .debug = true;
        .debug.showContent = true }
	Interfaces: getEvents
}

main {
    ListRepoEvents@EventsPort( )( e );
    valueToPrettyString@StringUtils( e )( s );
    println@Console( s )()
}

