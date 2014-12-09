include "console.iol"
include "string_utils.iol"
include "file.iol"

execution { concurrent }

type GHInfo:void {
    .username:string
    .repo:string
}

interface sendReq {
RequestResponse:
    getForm( void )( string ),
    ListEvents( GHInfo )( undefined )
}

inputPort MyInput {
Location: "socket://localhost:8000/"
Protocol: http {
    .format -> format;
    .debug = true;
    .debug.showContent = true
}
Interfaces: sendReq
}

outputPort GitHubPort {
	Location:
        "socket://api.github.com:443"	
    Protocol: https {
        .osc.ListEvents.alias = "repos/%{username}/%{repo}/events";
        .method = "get";
        .addHeader.header[0] = "User-Agent";
        .addHeader.header[0].value = "Blah";
        .ssl.protocol = "TLSv1.2";
        .debug = true;
        .debug.showContent = true }
	Interfaces: sendReq
}

main {
    [ ListEvents( req )( res ) {
        ListEvents@GitHubPort( req )( res )
        //valueToPrettyString@StringUtils( res )( s );
        //println@Console( s )()
    } ] { nullProcess }

    [ getForm()( form ) {
        format = "html";
        f.filename = "form.html";
        readFile@File( f ) ( form )
    } ] { nullProcess }
}

