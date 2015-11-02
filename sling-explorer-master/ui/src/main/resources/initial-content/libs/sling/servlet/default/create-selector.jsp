<%--
/************************************************************************
 **     $Date: $
 **   $Source: $
 **   $Author: $
 ** $Revision: $
 ************************************************************************/
--%><%
%>
<%@page session="false" contentType="text/html; charset=utf-8" %>
<%
%>
<%@page import="org.apache.sling.api.resource.*,
                java.util.*" %>
<%@ include file="/apps/sling-explorer/components/utils.jsp" %>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.3" %>
<%
%><sling:defineObjects/><%
    String type = slingRequest.getParameter("type");
    if (type == null) {
        type = "jcr:primaryType";
    }

    ValueMap map = resource.adaptTo(ValueMap.class);
    String rtype = map.get(type, String.class);
    if (rtype == null) {
        type = "jcr:primaryType";
        rtype = map.get(type, String.class);
    }

    rtype = rtype.replace(':', '/');

    String appspath = "/apps/" + rtype;
    String libspath = "/libs/" + rtype;
    String defpath = "/apps/sling/servlet/default/" + rtype;

%><!DOCTYPE html>
<html>
<sling:include resource="${resource}" replaceSelectors="head"/>
<body>
<div class="container-fluid">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Create/Edit Selector Script</h3>
            </div>

            <div class="modal-body">
                <%= type %>
                <p>
                <ul>
                    <li><a href="?type=jcr:primaryType">jcr:primaryType : <%= map.get("jcr:primaryType", "") %>
                    </a></li>
                    <li><a href="?type=sling:resourceType">sling:resourceType : <%= map.get("sling:resourceType", "") %>
                    </a></li>
                    <li><a href="?type=sling:superResourceType">sling:superResourceType
                        : <%= map.get("sling:superResourceType", "") %>
                    </a></li>
                </ul>
                <p>
                        <%=appspath %><a href="<%=appspath%>.edit.html"> <i
                        class="icon icon-circle-arrow-right"></i></a>

                <p>
                <ul style="list-style-type:none">
                    <%
                        Iterator<Resource> children = listResources(resource.getResourceResolver(), appspath);
                        while (children.hasNext()) {
                            Resource res = children.next();
                            String path = res.getPath();
                            String name = res.getName();
                    %>
                    <li><a href="<%=path%>.edit.html"><%= name %>
                    </a></li>
                    <% } %>
                    <form class="form-horizontal" method="post" action="<%= appspath %>" enctype="multipart/form-data">
                        <input type="hidden" name=":redirect" value="<%=slingRequest.getRequestURL() %>"/>
                        <input type="hidden" name=":errorpage" value="<%=slingRequest.getRequestURL()%>"/>
                        <input type="hidden" name=":operation" value="import"/>
                        <input type="hidden" name=":contentType" value="json"/>

                        <div class="input-group">
                            <input type="text" name=":name" class="form-control" placeholder="new selector script"/>

                            <input type="hidden" name=":content"
                                   value="{ 'jcr:primaryType':'nt:file','jcr:content':{'jcr:primaryType':'nt:resource','jcr:data':'','jcr:mimeType':'text/plain'} }"/>
                            <span class="input-group-btn">
                                <button class="btn btn-success" type="submit"><i class="glyphicon glyphicon-plus"></i>
                                </button>
                            </span>
                        </div>
                    </form>
                </ul>
                <%=libspath %><a href="<%=libspath%>.edit.html"> <i class="glyphicon glyphicon-circle-arrow-right"></i></a>

                <p>
                <ul>
                    <%
                        children = listResources(resource.getResourceResolver(), libspath);
                        while (children.hasNext()) {
                            Resource res = children.next();
                            String path = res.getPath();
                            String name = res.getName();
                    %>
                    <li><a href="<%=path%>.edit.html"><%= name %>
                    </a></li>
                    <% } %>

                    <form class="form-horizontal" method="post" action="<%= libspath %>" enctype="multipart/form-data">
                        <input type="hidden" name=":redirect" value="<%=slingRequest.getRequestURL() %>"/>
                        <input type="hidden" name=":errorpage" value="<%=slingRequest.getRequestURL()%>"/>
                        <input type="hidden" name=":operation" value="import"/>
                        <input type="hidden" name=":contentType" value="json"/>
                        <div class="input-group">
                            <input type="text" name=":name" placeholder="new selector script" class="form-control"/>
                            <input type="hidden" name=":content"
                                   value="{ 'jcr:primaryType':'nt:file','jcr:content':{'jcr:primaryType':'nt:resource','jcr:data':'','jcr:mimeType':'text/plain'} }"/>
                        <span class="input-group-btn">
                            <button class="btn btn-success" type="submit"><i class="glyphicon glyphicon-plus"></i>
                            </button>
                        </span>
                        </div>
                    </form>
                </ul>
                <%= defpath %><a href="<%=defpath%>.edit.html"> <i
                    class="glyphicon glyphicon-circle-arrow-right"></i></a>

                <p>
                <ul>
                    <%
                        children = listResources(resource.getResourceResolver(), defpath);
                        while (children.hasNext()) {
                            Resource res = children.next();
                            String path = res.getPath();
                            String name = res.getName();
                    %>
                    <li><a href="<%=path%>.edit.html"><%= name %>
                    </a></li>
                    <% } %>

                    <form class="form-horizontal" method="post" action="<%= defpath %>" enctype="multipart/form-data">
                        <input type="hidden" name=":redirect" value="<%=slingRequest.getRequestURL() %>"/>
                        <input type="hidden" name=":errorpage" value="<%=slingRequest.getRequestURL()%>"/>
                        <input type="hidden" name=":operation" value="import"/>
                        <input type="hidden" name=":contentType" value="json"/>

                        <div class="input-group">
                            <input type="text" name=":name" class="form-control" placeholder="new selector script"/>
                            <input type="hidden" name=":content"
                                   value="{ 'jcr:primaryType':'nt:file','jcr:content':{'jcr:primaryType':'nt:resource','jcr:data':'','jcr:mimeType':'text/plain'} }"/>
                        <span class="input-group-btn">
                            <button class="btn btn-success" type="submit"><i class="glyphicon glyphicon-plus"></i></button>
                            </span>
                        </div>
                    </form>
                </ul>

                <sling:include resource="<%=resource%>" replaceSelectors="errorbar"/>
            </div>
        </div>
    </div>
</div>
</div>
</body>
</html>
