/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.apache.sling.explorer.post;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.request.RequestParameter;
import org.apache.sling.api.request.RequestParameterMap;
import org.apache.sling.api.wrappers.SlingHttpServletRequestWrapper;

import java.util.*;

/**
 * Wraps a standard POST request.<br/>
 * Used to manipulate the POSTed data in order to support <code>@NameFrom</code> suffix
 * <br/>
 * Short example:<br/>
 * A typical case looks like this:         </br>
 * <pre>
 * :property_name='Name'
 * :property_name@NameFrom='Sky Lukewalker'
 * :property_name@TypeHint=String
 * </pre>
 *
 * This wrapper transforms these parameters in </br>
 * <pre>
 *  Name='Sky Lukewalker'
 *  Name@TypeHint=String
 * </pre>
 */
public class POSTRequestWrapper extends SlingHttpServletRequestWrapper {

    private static final String NAME_FROM_SUFFIX = "@NameFrom";
    private static final String DELETE_VALUE_SUFFIX = "@DeleteValue";
    private static final String VALUE_FROM_SUFFIX = "@ValueFrom";
    private static final String TYPE_HINT_SUFFIX = "@TypeHint";

    private ParameterMap mypars;

    static void dump(ParameterMap pars) {
        Iterator it = pars.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry vp = (Map.Entry) it.next();
            String key = (String) vp.getKey();
            RequestParameter[] val = (RequestParameter[]) vp.getValue();

            if (val != null) {
                for (int i = 0; i < val.length; i++) {
                    String v = val[i].getString();
                    System.out.println("\t" + v);
                }
            } else {
            }
        }
    }

    public POSTRequestWrapper(SlingHttpServletRequest req) {
        super(req);
        // this is the parameter map we get from the client
        RequestParameterMap pars = super.getRequestParameterMap();
        // this will be the new parameter map
        mypars = new ParameterMap();

        Iterator it = pars.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry vp = (Map.Entry) it.next();
            String key = (String) vp.getKey();
            RequestParameter[] val = (RequestParameter[]) vp.getValue();

            if (key.endsWith(NAME_FROM_SUFFIX)) {
                // look up the property which contains the name (i.e. has the @NameFrom suffix)
                String pname = key.substring(0, key.length() - NAME_FROM_SUFFIX.length());
                RequestParameter nval = pars.getValue(pname);
                if (nval != null) {
                    mypars.removeParameter(pname);
                    // put the right combination in our parameters map
                    mypars.setParameters(nval.getString(), val);
                }
            } else if (key.endsWith(TYPE_HINT_SUFFIX)) {
                String pName = key.substring(0, key.length() - NAME_FROM_SUFFIX.length());
                if (pars.containsKey(pName + NAME_FROM_SUFFIX)) {
                    RequestParameter propName = pars.getValue(pName);
                    mypars.setParameters(propName.getString() + TYPE_HINT_SUFFIX, pars.getValues(key));
                } else {
                    mypars.setParameters(key, val);
                }
            } else if (key.endsWith(DELETE_VALUE_SUFFIX)) {
                String pname = key.substring(0, key.length() - DELETE_VALUE_SUFFIX.length());
                RequestParameter[] nval = mypars.getValues(pname);
                if (nval != null) {
                    List<RequestParameter> v = new ArrayList<RequestParameter>();
                    for (int i = 0; i < nval.length; i++) {
                        String a = nval[i].getString();
                        if (a.equals(val[0].getString())) {
                        } else {
                            v.add(nval[i]);
                        }
                    }
                    nval = v.toArray(new RequestParameter[0]);
                    if (nval.length == 0) {
                        mypars.removeParameter(pname);
                    } else {
                        mypars.setParameters(pname, nval);
                    }
                }
            } else if (key.endsWith(VALUE_FROM_SUFFIX)) {
                String oname = key.substring(0, key.length() - VALUE_FROM_SUFFIX.length()); //the real property name
                String pname = val[0].getString(); //the tmp property name

                RequestParameter[] nval = pars.getValues(pname); //the values
                RequestParameter[] oval = pars.getValues(oname); //the existing values

                mypars.removeParameter(pname);

                if (oval != null) {
                    Vector v = new Vector();
                    for (int i = 0; i < oval.length; i++) {
                        v.add(oval[i]);
                    }
                    for (int i = 0; i < nval.length; i++) {
                        v.add(nval[i]);
                    }
                    nval = (RequestParameter[]) v.toArray(new RequestParameter[0]);
                    mypars.setParameters(oname, nval);
                } else {
                    mypars.setParameters(oname, nval);
                }
            } else {
                mypars.setParameters(key, val);
            }
        }
    }

    public String getParameter(String name) {
        if (name.equals(":redirect")) {
            RequestParameter v[] = mypars.getValues(name);
            if (v == null) {
                return null;
            } else {
                return v[v.length - 1].getString();
            }
        } else {
            RequestParameter v = mypars.getValue(name);
            if (v == null) {
                return null;
            } else
                return v.getString();
        }
    }

    public RequestParameterMap getRequestParameterMap() {
        return mypars;
    }

    public RequestParameter getRequestParameter(String name) {
        return mypars.getValue(name);
    }

    public RequestParameter[] getRequestParameters(String name) {
        return mypars.getValues(name);
    }
}


