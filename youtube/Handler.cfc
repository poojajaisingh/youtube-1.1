<!--- 
Project:     YouTube plugin for Mango Blog <http://mangoblog.org>Author:      Seb Duggan <seb@sebduggan.com>Version:     1.1Build date:  2009-02-03 10:06:55Check for updated versions at <http://code.google.com/p/mangoplugins/>


Copyright 2009 Seb Duggan

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--->

<cfcomponent>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />	
		
		<cfset variables.manager = arguments.mainManager />
		<cfset variables.preferences = arguments.preferences />
		<cfreturn this/>
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getName" access="public" output="false" returntype="string">
		<cfreturn variables.name />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfargument name="name" type="string" required="true" />
		<cfset variables.name = arguments.name />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="getId" access="public" output="false" returntype="any">
		<cfreturn variables.id />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="setId" access="public" output="false" returntype="void">
		<cfargument name="id" type="any" required="true" />
		<cfset variables.id = arguments.id />
	</cffunction>
	
<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="boolean">
		
		<cfreturn true />
	</cffunction>

	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">

		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />

		<cfreturn />
	</cffunction>

<!--- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		
		<cfset var eventName = arguments.event.getName() />
		<cfset var data = "" />
		<cfset var match = "" />
		<cfset var noMoreMatches = false />
		<cfset var fullTag = "" />
		<cfset var videoId = "" />
		<cfset var embedCode = "" />
		
		
		<cfif eventName is "pageGetContent" or eventName is "postGetContent">
			<cfset data = arguments.event.accessObject />			
			
			<cfloop condition="noMoreMatches is false"> 
			
				<cfset match = refindnocase("\[youtube:([-_[:alnum:]]+)\]", data.content, 1, true) />
								
				<cfif match.len[1] eq 0>
					<cfset noMoreMatches = true />
				<cfelse>
					<cfset fullTag = mid(data.content, match.pos[1], match.len[1]) />
					<cfset videoId = mid(data.content, match.pos[2], match.len[2]) />
					
					<cfsavecontent variable="embedCode"><cfoutput>
					<object width="425" height="355">
						<param name="movie" value="http://www.youtube.com/v/#videoId#&rel=1"></param>
						<param name="wmode" value="transparent"></param>
						<embed src="http://www.youtube.com/v/#videoId#&rel=1" type="application/x-shockwave-flash" wmode="transparent" width="425" height="355"></embed>
					</object>
					</cfoutput></cfsavecontent>
					<cfset data.content = replace(data.content, fullTag, embedCode, "all") />
				</cfif>
			 
			</cfloop>
					
		</cfif>	
		
		<cfreturn arguments.event />
	</cffunction>

</cfcomponent>