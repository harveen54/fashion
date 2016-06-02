/* *************************************************************************
// *                                                                       *
// * nopAccelerate - Solr Integration Extension for nopCommerce            *
// * Copyright (c) Xcellence-IT. All Rights Reserved.                      *
// *                                                                       *
// *************************************************************************
// *                                                                       *
// * Email: info@nopaccelerate.com                                         *
// * Website: http://www.nopaccelerate.com                                 *
// *                                                                       *
// *************************************************************************
// *                                                                       *
// * This  software is furnished  under a license  and  may  be  used  and *
// * modified  only in  accordance with the terms of such license and with *
// * the  inclusion of the above  copyright notice.  This software or  any *
// * other copies thereof may not be provided or  otherwise made available *
// * to any  other  person.   No title to and ownership of the software is *
// * hereby transferred.                                                   *
// *                                                                       *
// * You may not reverse  engineer, decompile, defeat  license  encryption *
// * mechanisms  or  disassemble this software product or software product *
// * license.  Xcellence-IT may terminate this license if you don't comply *
// * with  any  of  the  terms and conditions set forth in  our  end  user *
// * license agreement (EULA).  In such event,  licensee  agrees to return *
// * licensor  or destroy  all copies of software  upon termination of the *
// * license.                                                              *
// *                                                                       *
// * Please see the  License file for the full End User License Agreement. *
// * The  complete license agreement is also available on  our  website at * 
// * http://www.nopaccelerate.com/terms/                                   *
// *                                                                       *
// ************************************************************************* */

$(document).on("keyup", ".npacc-filter-search", function () {

    //http://stackoverflow.com/questions/11083768/after-ajax-call-jquery-function-not-working-properly

    //Search filter
    SearchFilter($(this).val(), $(this).attr('id'));

    //Store text in browser
    WebStorageFilter($(this).val(), $(this).attr('id'), true);

});
$(document).ready(function () {
    ClearWebStorageFilter();

    //Lazy Loading
    $("img.lazy").show().lazyload({
        effect: "fadeIn"
    });

});

function UpdateQueryString(key, value, url) {
    if (!url) url = window.location.href;
    var re = new RegExp("([?|&])" + key + "=.*?(&|#|$)(.*)", "gi");


    if (re.test(url)) {
        if (typeof value !== 'undefined' && value !== null)
            return url.replace(re, '$1' + key + "=" + value + '$2$3');
        else {
            return url.replace(re, '$1$3').replace(/(&|\?)$/, '');
        }
    }
    else {
        if (typeof value !== 'undefined' && value !== null) {
            var separator = url.indexOf('?') !== -1 ? '&' : '?',
                hash = url.split('#');
            url = hash[0] + separator + key + '=' + value;
            if (hash[1]) url += '#' + hash[1];
            return url;
        }
        else
            return url;
    }
}

//Display text of particular filter search text box
function DisplayFilterSearchBoxValue() {
    $(".npacc-filter-search").each(function () {
        WebStorageFilter(null, $(this).attr("id"), false);
    });
}

//Collapse filter 
function SlideUpDown(divId, arrowId) {
    if ($('#' + divId).is(':visible')) {
        $('#' + divId).slideUp("slow");
        $('#' + arrowId).attr('class', 'arrow rotate');
    }
    else {
        $('#' + divId).slideDown("slow");
        $('#' + arrowId).attr('class', 'arrow');
    }

}


//Clear all filter search text from browser
$("#npacc-clearAll").click(function () {
    ClearWebStorageFilter();
});


//Ajax call caching
var localCache = {
    timeout: 600000, //in milisecond
    data: {},
    remove: function (url) {
        delete localCache.data[url];
    },
    exist: function (url) {
        return !!localCache.data[url] && ((new Date().getTime() - localCache.data[url]._) < localCache.timeout);
    },
    get: function (url) {
        console.log('Getting in cache for url' + url);
        return localCache.data[url].data;
    },
    set: function (url, cachedData, callback) {
        localCache.remove(url);
        localCache.data[url] = {
            _: new Date().getTime(),
            data: cachedData
        };
        if ($.isFunction(callback)) callback(cachedData);
    }
};

function callAjax(url, expire) {
    $('#npacc-ajax-loading').show(); //Show  ajax loader
    $.ajax({
        url: url,
        type: 'POST',
        cache: false,
        async: true,
        beforeSend: function () {
            if (localCache.exist(url)) {
                doSomething(localCache.get(url));
                return false;
            }
            return true;
        },
        complete: function (jqXHR, textStatus) {
        },
        success: function (result) {
            if (expire != undefined) {
                localCache.timeout = expire;
            }
            else { localCache.timeout = 600000; }
            localCache.set(url, result, doSomething);
        }
    });
}

function doSomething(data) {
    $('#npacc-search').replaceWith(data);
    $('#npacc-ajax-loading').hide();
    if (($('.pager').find('li').text() == "") && ($('#product-grid').length > 0)) {
        $('#product-grid').jscroll.destroy();
    }
    var n = $("input:checked").length;
    var tempURL = window.location.href.toLowerCase();
    if (tempURL.indexOf("as=true") != -1) {
        if (n > 1) {
            $('#npacc-clearAll').attr('style', 'display:block;');
        }
    }
    else {
        if (n > 0) {
            $('#npacc-clearAll').attr('style', 'display:block;');
        }
    }
    DisplayFilterSearchBoxValue();
    if (typeof (keepPriceRangeAfterRefresh) !== 'undefined') {
        keepPriceRangeAfterRefresh(); //Keeping price range selection after ajax call..
    }
    //Lazy Loading
    $("img.lazy").show().lazyload({
        effect: "fadeIn"
    });
    $(window).trigger("scroll");
}

//start: removable tag filters
function prepareSpecificationFilterTags(url) {
    var filterString = '';
    $('ul#tagsList').html(filterString);

    if (url) {
        var queryAttributes = url.split('?')[1];
        queryAttributes = queryAttributes.split('&');
        queryAttributes.forEach(function (specAttr) {
            var repColon = replaceAllString(specAttr, "%3a", ":");
            var repComma = replaceAllString(repColon, "%2c", ",");
            var repSeperator = replaceAllString(repComma, "%7c", "|");
            var IsSecification = (repSeperator.indexOf("specs=") >= 0);
            var IsCategory = (repSeperator.indexOf("category=") >= 0);
            var IsVendor = (repSeperator.indexOf("vendor=") >= 0);
            var IsManufacturer = (repSeperator.indexOf("manufacturer=") >= 0);
            var IsRating = (repSeperator.indexOf("rating=") >= 0);
            if ((IsSecification) || (IsCategory) || (IsVendor) || (IsManufacturer)) {
                repSeperator = repSeperator.replace("specs=", "").replace("category=", "").replace("vendor=", "").replace("manufacturer=", "");
                var selOptions = repSeperator.split("||");
                selOptions.forEach(function (tag) {
                    if (tag) {
                        var filterPair = tag;
						var value = "";
                        tag = replaceAllString(tag, "+", " ").replace("pa_", "").replace("f_", "").split(':');
                        filterString += '<li><input type="hidden" value="' + filterPair + '" class="filterPair" /><span class="tag" title="Remove This Filter"><span>' + decodeURIComponent(tag[0]) + '</span> : ';

                        if (IsSecification) {
                            if (tag[1].indexOf("%23") >= 0) {
                                value = tag[1].split('%23');
                                filterString += '<span class="sSpecification">' + decodeURIComponent(value[0]) + '</span><span class="remove">x</span></span></li>';
                            }
                            else { filterString += '<span class="sSpecification">' + decodeURIComponent(tag[1]) + '</span><span class="remove">x</span></span></li>'; }
                        } else if (IsCategory) {
                            filterString += '<span class="sCategory">' + decodeURIComponent(tag[1]) + '</span><span class="remove">x</span></span></li>';
                        } else if (IsVendor) {
                            filterString += '<span class="sVendor">' + decodeURIComponent(tag[1]) + '</span><span class="remove">x</span></span></li>';
                        } else if (IsManufacturer) {
                            filterString += '<span class="sManufacturer">' + decodeURIComponent(tag[1]) + '</span><span class="remove">x</span></span></li>';
                        }
                    }
                });
            } else if (repSeperator.indexOf("stock=exclude_out_of_stock_products") >= 0) {
                var tag = "Exclude Out Of Stock";
                filterString += '<li><span class="tag" title="Remove This Filter"><span>Availability</span> : ';
                filterString += '<span class="sStock">' + tag + '</span><span class="remove">x</span></span></li>';
            } else if (repSeperator.indexOf("stock=include_out_of_stock_products") >= 0) {
                var tag = "Include Out Of Stock";
                filterString += '<li><span class="tag" title="Remove This Filter"><span>Availability</span> : ';
                filterString += '<span class="sStock">' + tag + '</span><span class="remove">x</span></span></li>';
            } else if (repSeperator.indexOf("rating=") >= 0) {
                repSeperator = repSeperator.replace("rating=", "");
                var tag = repSeperator;
                filterString += '<li><span class="tag" title="Remove This Filter"><span>Rating</span> : ';
                filterString += '<span class="sRating">' + tag + '</span><span class="remove">x</span></span></li>';
            } else if (repSeperator.indexOf("price=") >= 0) {
                repSeperator = repSeperator.replace("price=", "");
                var tag = repSeperator;
                filterString += '<li><span class="tag" title="Remove This Filter"><span>Price</span> : ';
                filterString += '<span class="sPrice">' + tag + '</span><span class="remove">x</span></span></li>';
            }
        });

        $('ul#tagsList').append(filterString);
    }
}
function replaceAllString(string, find, replace) {
    //custom funcrion to replace all the occurences of string
    var str = string.replace(new RegExp(escapeRegExp(find), 'g'), replace);
    return str;
}
function escapeRegExp(string) {
    return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}
function removeParameter(url, parameter) {
    var urlparts = url.split('?');

    if (urlparts.length >= 2) {
        var urlBase = urlparts.shift(); //get first part, and remove from array
        var queryString = urlparts.join("?"); //join it back up

        var prefix = encodeURIComponent(parameter) + '=';
        var pars = queryString.split(/[&;]/g);
        for (var i = pars.length; i-- > 0;)               //reverse iteration as may be destructive
            if (pars[i].lastIndexOf(prefix, 0) !== -1)   //idiom for string.startsWith
                pars.splice(i, 1);
        url = urlBase + '?' + pars.join('&');
    }
    return url;
}
//end: removable tag filters

//Clear all filter search text from browser
function ClearWebStorageFilter() {
    if (typeof (Storage) !== "undefined") {
        sessionStorage.clear();
    }
}
//Store filter search text in browser
function WebStorageFilter(keyword, id, isAjaxRequest) {
    var sessionStorageId = "sessionStorageId-" + id;

    if (!isAjaxRequest) {

        if (typeof (Storage) !== "undefined") {

            if (sessionStorage[sessionStorageId] !== "undefined" && sessionStorage[sessionStorageId] !== "") {
                $("#" + id).val(sessionStorage[sessionStorageId]);
                SearchFilter(sessionStorage[sessionStorageId], id);
            }
        }
    }
    else {
        if (typeof (Storage) !== "undefined") {
            if (sessionStorage[sessionStorageId] !== "undefined" && sessionStorage[sessionStorageId] !== "") {
                sessionStorage[sessionStorageId] = keyword;
            }
            else {
                sessionStorage[sessionStorageId] = "";
                sessionStorage[sessionStorageId] = keyword;
            }
        }
    }
}

//Search in filter
function SearchFilter(keyword, id) {
    var found = false;
    $("#" + id + "-item li").each(function (li) {
        var originalText = $(this).find("span").attr("original");
        var regExp = new RegExp(keyword, 'i');
        if (regExp.test(originalText)) {
            $(this).show();

            //Highlights searched text
            $oldcontent = $(this).find("span").attr("original");
            $(this).find("span").html($oldcontent.replace(regExp.exec(originalText), '<em class="matched">' + regExp.exec(originalText) + '</em>'));

        }
        else {
            $(this).hide();
        }
    });
}

// fix for ie8 printed checkbox bug using jquery
//http://stackoverflow.com/questions/1414748/internet-explorer-8-and-checkbox-css-problem
$('input[type=checkbox]').live('change', function () {
    if ($(this).is(':checked')) {
        $(this).attr('checked', true);
    } else {
        $(this).attr('checked', false);
    }
});

function npAccFiltersPushStateUrl(stateUrl) {
    manualStateChange = false;
    History.pushState({ loadUrl: stateUrl, rand: Math.random() }, document.title, stateUrl);
    return false;
}

//function called when back and forward button click of any browser
$(function () {
    // history.js
    History.Adapter.bind(window, 'statechange', function () {
        var State = History.getState();
        var url = State.data.loadUrl == 'undefined' ? State.data.loadUrl : State.url;
        if (typeof (manualStateChange) !== 'undefined' && manualStateChange == true) {
            callAjax(url);
        }
        else if (typeof (State.data.loadUrl) == 'undefined') {
            callAjax(url);
        }
        manualStateChange = true;
        return false;
    });
});