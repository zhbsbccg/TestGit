(function () {
    /* global window */
    /* jslint browser: true, devel: true, undef: true, nomen: true, bitwise: true, regexp: true, newcap: true, immed: true */
    
    /**
     * Wrapper for FireBug's console.log
     */
    function log(){
        if (typeof(console) != 'undefined' && typeof(console.log) == 'function'){            
            Array.prototype.unshift.call(arguments, '[Ajax Upload]');
            console.log( Array.prototype.join.call(arguments, ' '));
        }
    } 

    /**
     * Attaches event to a dom element.
     * @param {Element} el
     * @param type event name
     * @param fn callback This refers to the passed element
     */
    function addEvent(el, type, fn){
        if (el.addEventListener) {
            el.addEventListener(type, fn, false);
        } else if (el.attachEvent) {
            el.attachEvent('on' + type, function(){
                fn.call(el);
	        });
	    } else {
            throw new Error('not supported or DOM not loaded');
        }
    }   
    
    /**
     * Attaches resize event to a window, limiting
     * number of event fired. Fires only when encounteres
     * delay of 100 after series of events.
     * 
     * Some browsers fire event multiple times when resizing
     * http://www.quirksmode.org/dom/events/resize.html
     * 
     * @param fn callback This refers to the passed element
     */
    function addResizeEvent(fn){
        var timeout;
               
	    addEvent(window, 'resize', function(){
            if (timeout){
                clearTimeout(timeout);
            }
            timeout = setTimeout(fn, 100);                        
        });
    }    
    
    // Needs more testing, will be rewriten for next version        
    // getOffset function copied from jQuery lib (http://jquery.com/)
    if (document.documentElement.getBoundingClientRect){
        // Get Offset using getBoundingClientRect
        // http://ejohn.org/blog/getboundingclientrect-is-awesome/
        var getOffset = function(el){
            var box = el.getBoundingClientRect();
            var doc = el.ownerDocument;
            var body = doc.body;
            var docElem = doc.documentElement; // for ie 
            var clientTop = docElem.clientTop || body.clientTop || 0;
            var clientLeft = docElem.clientLeft || body.clientLeft || 0;
             
            // In Internet Explorer 7 getBoundingClientRect property is treated as physical,
            // while others are logical. Make all logical, like in IE8.	
            var zoom = 1;            
            if (body.getBoundingClientRect) {
                var bound = body.getBoundingClientRect();
                zoom = (bound.right - bound.left) / body.clientWidth;
            }
            
            if (zoom > 1) {
                clientTop = 0;
                clientLeft = 0;
            }
            
            var top = box.top / zoom + (window.pageYOffset || docElem && docElem.scrollTop / zoom || body.scrollTop / zoom) - clientTop, left = box.left / zoom + (window.pageXOffset || docElem && docElem.scrollLeft / zoom || body.scrollLeft / zoom) - clientLeft;
            
            return {
                top: top,
                left: left
            };
        };        
    } else {
        // Get offset adding all offsets 
        var getOffset = function(el){
            var top = 0, left = 0;
            do {
                top += el.offsetTop || 0;
                left += el.offsetLeft || 0;
                el = el.offsetParent;
            } while (el);
            
            return {
                left: left,
                top: top
            };
        };
    }
    
    /**
     * Returns left, top, right and bottom properties describing the border-box,
     * in pixels, with the top-left relative to the body
     * @param {Element} el
     * @return {Object} Contains left, top, right,bottom
     */
    function getBox(el){
        var left, right, top, bottom;
        var offset = getOffset(el);
        left = offset.left;
        top = offset.top;
        
        right = left + el.offsetWidth;
        bottom = top + el.offsetHeight;
        
        return {
            left: left,
            right: right,
            top: top,
            bottom: bottom
        };
    }
    
    /**
     * Helper that takes object literal
     * and add all properties to element.style
     * @param {Element} el
     * @param {Object} styles
     */
    function addStyles(el, styles){
        for (var name in styles) {
            if (styles.hasOwnProperty(name)) {
                el.style[name] = styles[name];
            }
        }
    }
        
    /**
     * Function places an absolutely positioned
     * element on top of the specified element
     * copying position and dimentions.
     * @param {Element} from
     * @param {Element} to
     */    
    function copyLayout(from, to){
	    var box = getBox(from);
        
        addStyles(to, {
	        position: 'absolute',                    
	        left : box.left + 'px',
	        top : box.top + 'px',
	        width : from.offsetWidth + 'px',
	        height : from.offsetHeight + 'px'
	    });        
    }

    /**
    * Creates and returns element from html chunk
    * Uses innerHTML to create an element
    */
    var toElement = (function(){
        var div = document.createElement('div');
        return function(html){
            div.innerHTML = html;
            var el = div.firstChild;
            return div.removeChild(el);
        };
    })();
            
    /**
     * Function generates unique id
     * @return unique id 
     */
    var getUID = (function(){
        var id = 0;
        return function(){
            return 'ValumsAjaxUpload' + id++;
        };
    })();        
 
    /**
     * Get file name from path
     * @param {String} file path to file
     * @return filename
     */  
    function fileFromPath(file){
        return file.replace(/.*(\/|\\)/, "");
    }
    
    /**
     * Get file extension lowercase
     * @param {String} file name
     * @return file extenstion
     */    
    function getExt(file){
        return (-1 !== file.indexOf('.')) ? file.replace(/.*[.]/, '') : '';
    }

    function hasClass(el, name){        
        var re = new RegExp('\\b' + name + '\\b');        
        return re.test(el.className);
    }    
    function addClass(el, name){
        if ( ! hasClass(el, name)){   
            el.className += ' ' + name;
        }
    }    
    function removeClass(el, name){
        var re = new RegExp('\\b' + name + '\\b');                
        el.className = el.className.replace(re, '');        
    }
    
    function removeNode(el){
        el.parentNode.removeChild(el);
    }

    /**
     * Easy styling and uploading
     * @constructor
     * @param button An element you want convert to 
     * upload button. Tested dimentions up to 500x500px
     * @param {Object} options See defaults below.
     */
    window.AjaxUpload = function(button, options){
        this._settings = {
            // Location of the server-side upload script
            action: 'upload.php',
            // File upload name
            name: 'userfile',
            // Additional data to send
            data: {},
            // Submit file as soon as it's selected
            autoSubmit: true,
            // The type of data that you're expecting back from the server.
            // html and xml are detected automatically.
            // Only useful when you are using json data as a response.
            // Set to "json" in that case. 
            responseType: false,
            // Class applied to button when mouse is hovered
            hoverClass: 'hover',
            // Class applied to button when AU is disabled
            disabledClass: 'disabled',            
            // When user selects a file, useful with autoSubmit disabled
            // You can return false to cancel upload			
            onChange: function(file, extension){
            },
            // Callback to fire before file is uploaded
            // You can return false to cancel upload
            onSubmit: function(file, extension){
            },
            // Fired when file upload is completed
            // WARNING! DO NOT USE "FALSE" STRING AS A RESPONSE!
            onComplete: function(file, response){
            }
        };
                        
        // Merge the users options with our defaults
        for (var i in options) {
            if (options.hasOwnProperty(i)){
                this._settings[i] = options[i];
            }
        }
                
        // button isn't necessary a dom element
        if (button.jquery){
            // jQuery object was passed
            button = button[0];
        } else if (typeof button == "string") {
            if (/^#.*/.test(button)){
                // If jQuery user passes #elementId don't break it					
                button = button.slice(1);                
            }
            
            button = document.getElementById(button);
        }
        
        if ( ! button || button.nodeType !== 1){
            //throw new Error("Please make sure that you're passing a valid element"); 
        }
                
        if ( button.nodeName.toUpperCase() == 'A'){
            // disable link                       
            addEvent(button, 'click', function(e){
                if (e && e.preventDefault){
                    e.preventDefault();
                } else if (window.event){
                    window.event.returnValue = false;
                }
            });
        }
                    
        // DOM element
        this._button = button;        
        // DOM element                 
        this._input = null;
        // If disabled clicking on button won't do anything
        this._disabled = false;
        
        // if the button was disabled before refresh if will remain
        // disabled in FireFox, let's fix it
        this.enable();        
        
        this._rerouteClicks();
    };
    
    // assigning methods to our class
    AjaxUpload.prototype = {
        setData: function(data){
            this._settings.data = data;
        },
        disable: function(){            
            addClass(this._button, this._settings.disabledClass);
            this._disabled = true;
            
            var nodeName = this._button.nodeName.toUpperCase();            
            if (nodeName == 'INPUT' || nodeName == 'BUTTON'){
                this._button.setAttribute('disabled', 'disabled');
            }            
            
            // hide input
            if (this._input){
                // We use visibility instead of display to fix problem with Safari 4
                // The problem is that the value of input doesn't change if it 
                // has display none when user selects a file           
                this._input.parentNode.style.visibility = 'hidden';
            }
        },
        enable: function(){
            removeClass(this._button, this._settings.disabledClass);
            this._button.removeAttribute('disabled');
            this._disabled = false;
            
        },
        /**
         * Creates invisible file input 
         * that will hover above the button
         * <div><input type='file' /></div>
         */
        _createInput: function(){ 
            var self = this;
                        
            var input = document.createElement("input");
            input.setAttribute('type', 'file');
            input.setAttribute('name', this._settings.name);
            
            addStyles(input, {
                'position' : 'absolute',
                // in Opera only 'browse' button
                // is clickable and it is located at
                // the right side of the input
                'right' : 0,
                'margin' : 0,
                'padding' : 0,
                'fontSize' : '480px',                
                'cursor' : 'pointer'
            });            

            var div = document.createElement("div");                        
            addStyles(div, {
                'display' : 'block',
                'position' : 'absolute',
                'overflow' : 'hidden',
                'margin' : 0,
                'padding' : 0,                
                'opacity' : 0,
                // Make sure browse button is in the right side
                // in Internet Explorer
                'direction' : 'ltr',
                //Max zIndex supported by Opera 9.0-9.2
                'zIndex': 2147483583
            });
            
            // Make sure that element opacity exists.
            // Otherwise use IE filter            
            if ( div.style.opacity !== "0") {
                if (typeof(div.filters) == 'undefined'){
                    throw new Error('Opacity not supported by the browser');
                }
                div.style.filter = "alpha(opacity=0)";
            }            
            
            addEvent(input, 'change', function(){
                 
                if ( ! input || input.value === ''){                
                    return;                
                }
                            
                // Get filename from input, required                
                // as some browsers have path instead of it          
                var file = fileFromPath(input.value);
                                
                if (false === self._settings.onChange.call(self, file, getExt(file))){
                    self._clearInput();                
                    return;
                }
                
                // Submit form when value is changed
                if (self._settings.autoSubmit) {
                    self.submit();
                }
            });            

            addEvent(input, 'mouseover', function(){
                addClass(self._button, self._settings.hoverClass);
            });
            
            addEvent(input, 'mouseout', function(){
                removeClass(self._button, self._settings.hoverClass);
                
                // We use visibility instead of display to fix problem with Safari 4
                // The problem is that the value of input doesn't change if it 
                // has display none when user selects a file           
                //input.parentNode.style.visibility = 'hidden';

            });   
                        
	        div.appendChild(input);
            document.body.appendChild(div);
              
            this._input = input;
        },
        _clearInput : function(){
            if (!this._input){
                return;
            }            
                             
            // this._input.value = ''; Doesn't work in IE6                               
            removeNode(this._input.parentNode);
            this._input = null;                                                                   
            this._createInput();
            
            removeClass(this._button, this._settings.hoverClass);
        },
        /**
         * Function makes sure that when user clicks upload button,
         * the this._input is clicked instead
         */
        _rerouteClicks: function(){
            var self = this;
            
            // IE will later display 'access denied' error
            // if you use using self._input.click()
            // other browsers just ignore click()

            addEvent(self._button, 'mouseover', function(){
                if (self._disabled){
                    return;
                }
                                
                if ( ! self._input){
	                self._createInput();
                }
                
                var div = self._input.parentNode;                            
                copyLayout(self._button, div);
                div.style.visibility = 'visible';
                                
            });
            
            
            // commented because we now hide input on mouseleave
            /**
             * When the window is resized the elements 
             * can be misaligned if button position depends
             * on window size
             */
            //addResizeEvent(function(){
            //    if (self._input){
            //        copyLayout(self._button, self._input.parentNode);
            //    }
            //});            
                                         
        },
        /**
         * Creates iframe with unique name
         * @return {Element} iframe
         */
        _createIframe: function(){
            // We can't use getTime, because it sometimes return
            // same value in safari :(
            var id = getUID();            
             
            // We can't use following code as the name attribute
            // won't be properly registered in IE6, and new window
            // on form submit will open
            // var iframe = document.createElement('iframe');
            // iframe.setAttribute('name', id);                        
 
            var iframe = toElement('<iframe src="javascript:false;" name="' + id + '" />');
            // src="javascript:false; was added
            // because it possibly removes ie6 prompt 
            // "This page contains both secure and nonsecure items"
            // Anyway, it doesn't do any harm.            
            iframe.setAttribute('id', id);
            
            iframe.style.display = 'none';
            document.body.appendChild(iframe);
            
            return iframe;
        },
        /**
         * Creates form, that will be submitted to iframe
         * @param {Element} iframe Where to submit
         * @return {Element} form
         */
        _createForm: function(iframe){
            var settings = this._settings;
                        
            // We can't use the following code in IE6
            // var form = document.createElement('form');
            // form.setAttribute('method', 'post');
            // form.setAttribute('enctype', 'multipart/form-data');
            // Because in this case file won't be attached to request                    
            var form = toElement('<form method="post" enctype="multipart/form-data"></form>');
                        
            form.setAttribute('action', settings.action);
            form.setAttribute('target', iframe.name);                                   
            form.style.display = 'none';
            document.body.appendChild(form);
            
            // Create hidden input element for each data key
            for (var prop in settings.data) {
                if (settings.data.hasOwnProperty(prop)){
                    var el = document.createElement("input");
                    el.setAttribute('type', 'hidden');
                    el.setAttribute('name', prop);
                    el.setAttribute('value', settings.data[prop]);
                    form.appendChild(el);
                }
            }
            return form;
        },
        /**
         * Gets response from iframe and fires onComplete event when ready
         * @param iframe
         * @param file Filename to use in onComplete callback 
         */
        _getResponse : function(iframe, file){            
            // getting response
            var toDeleteFlag = false, self = this, settings = this._settings;   
               
            addEvent(iframe, 'load', function(){                
                
                if (// For Safari 
                    iframe.src == "javascript:'%3Chtml%3E%3C/html%3E';" ||
                    // For FF, IE
                    iframe.src == "javascript:'<html></html>';"){                                                                        
                        // First time around, do not delete.
                        // We reload to blank page, so that reloading main page
                        // does not re-submit the post.
                        
                        if (toDeleteFlag) {
                            // Fix busy state in FF3
                            setTimeout(function(){
                                removeNode(iframe);
                            }, 0);
                        }
                                                
                        return;
                }
                
                var doc = iframe.contentDocument ? iframe.contentDocument : window.frames[iframe.id].document;
                
                // fixing Opera 9.26,10.00
                if (doc.readyState && doc.readyState != 'complete') {
                   // Opera fires load event multiple times
                   // Even when the DOM is not ready yet
                   // this fix should not affect other browsers
                   return;
                }
                
                // fixing Opera 9.64
                if (doc.body && doc.body.innerHTML == "false") {
                    // In Opera 9.64 event was fired second time
                    // when body.innerHTML changed from false 
                    // to server response approx. after 1 sec
                    return;
                }
                
                var response;
                
                if (doc.XMLDocument) {
                    // response is a xml document Internet Explorer property
                    response = doc.XMLDocument;
                } else if (doc.body){
                    // response is html document or plain text
                    response = doc.body.innerHTML;
                    
                    if (settings.responseType && settings.responseType.toLowerCase() == 'json') {
                        // If the document was sent as 'application/javascript' or
                        // 'text/javascript', then the browser wraps the text in a <pre>
                        // tag and performs html encoding on the contents.  In this case,
                        // we need to pull the original text content from the text node's
                        // nodeValue property to retrieve the unmangled content.
                        // Note that IE6 only understands text/html
                        if (doc.body.firstChild && doc.body.firstChild.nodeName.toUpperCase() == 'PRE') {
                            response = doc.body.firstChild.firstChild.nodeValue;
                        }
                        
                        if (response) {
                            response = eval("(" + response + ")");
                        } else {
                            response = {};
                        }
                    }
                } else {
                    // response is a xml document
                    response = doc;
                }
                
                settings.onComplete.call(self, file, response);
                
                // Reload blank page, so that reloading main page
                // does not re-submit the post. Also, remember to
                // delete the frame
                toDeleteFlag = true;
                
                // Fix IE mixed content issue
                iframe.src = "javascript:'<html></html>';";
            });            
        },        
        /**
         * Upload file contained in this._input
         */
        submit: function(){                        
            var self = this, settings = this._settings;
            
            if ( ! this._input || this._input.value === ''){                
                return;                
            }
                                    
            var file = fileFromPath(this._input.value);
            
            // user returned false to cancel upload
            if (false === settings.onSubmit.call(this, file, getExt(file))){
                this._clearInput();                
                return;
            }
            
            // sending request    
            var iframe = this._createIframe();
            var form = this._createForm(iframe);
            
            // assuming following structure
            // div -> input type='file'
            removeNode(this._input.parentNode);            
            removeClass(self._button, self._settings.hoverClass);
                        
            form.appendChild(this._input);
                        
            form.submit();

            // request set, clean up                
            removeNode(form); form = null;                          
            removeNode(this._input); this._input = null;
            
            // Get response from iframe and fire onComplete event when ready
            this._getResponse(iframe, file);            

            // get ready for next request            
            this._createInput();
        }
    };
})();
// JavaScript Document
var CkeditorExt=null;
(function(){
	function get(o){return (typeof(o)=='string')?$GetEle(o):o;}
	// ������
	CkeditorExt={
		editorName:[],
		editorObjs:{},//FF�¶���༭��ʱ��FCKEditorApi��ȡ����ǰ��Ķ���,ֻ�ܻ�ȡ���һ��
		txtChecked:[],
		isEn:false,
		basePath:'/wui/common/js/ckeditor/',
		initEditor:_initEditor,
		//initUploadImage:_initUploadImage,
		id:'insertObjectContainer',
		updateContent:_updateContent,
		getHtml:_getHtml,
		setHtml:_setHtml,
		insertHtml:_insertHtml,
		getText:_getText,
		getTextNew:_getTextNew,
		selectImageType:_selectImageType,
		Ok:_Ok,
		Cancel:_Cancel,
		show:_show,
		showFlashDialog:_showFlashDialog,
		flashVideoDialog:_flashVideoDialog,
		switchEditMode:_switchEditMode,
		switchTextMode:_switchTextMode,
		removeFile:_removeFile,
		FullScreen:_fullScreen,
		InsertVideo:_InsertVideo,
		_sel:null,/**��¼ǰ��ѡ�еĶ���*/
		checkText:_checkText,
		_loadComplete:_loadComplete,
		toolbarExpand:_toolbarExpand,
		DEFAULT:1,
		NO_IMAGE:2,
		WEB_IMAGE:3,
		HtmlLayout_IMAGE:4,
		stripScripts:_stripScripts,
		filterXss:_filterXss,
		resize:_resize
	};
	
	var isInit=false;
	var _formName=null;
	//ckedit�༭���Ƿ������ɣ���ʼ��Ϊfalse��reader�¼����˱�����Ϊtrue�����ڰ��¼�
	var _ckeditReader = false;
	/**
	 * �ж϶����Ƿ�Ϊ��
	 * @param s
	 * @return
	 */
	function isEmpty(s){return (typeof(s)=='undefined' || s==null || s.toString()=='');}
	
	/**
	 * ��ʼ���༭��
	 * @param formName ������
	 * @param name     �༭������
	 * @param isEnglish �Ƿ�Ӣ��
	 * @param isNonImage �Ƿ���ͼƬ��ť
	 * @return
	 */
	function _initEditor(formName,name,isEnglish,isNonImage,height,toolbar){
		//����
	
		enableAllmenu();
		enablePhraseselect();
		if(height==undefined){
			height = 80;
		}
		
		//
		var sBasePath=this.basePath;
		this.editorName[this.editorName.length]=name;
		this.txtChecked[this.txtChecked.length]=false;
		_formName=formName;
		
		//_overLoadSubmit();//�����û��Զ���Submit
		//���ɱ༭��
		var oFCKeditor = CKEDITOR.replace(name,{height:height});
		
		//���������ļ�
		/*if(isNonImage==this.HtmlLayout_IMAGE){
			oFCKeditor.Config["CustomConfigurationsPath"]=sBasePath+"wfEditorConf.js";
		}else{
			oFCKeditor.Config["CustomConfigurationsPath"]=sBasePath+"weaverEditorConf.js";
		}*/
		
		//�༭������
		isEnglish=(isEnglish==8)?true:false;

		if(isEnglish){//�������Ƕ�ȡ������Ĭ��Ϊ��������
			oFCKeditor.config.language="en";
			this.isEn=true;
		}
		//alert(this.isEn)
		//���ù�����
		if(toolbar==undefined){
			toolbar = "base";
			oFCKeditor.config.toolbarStartupExpanded = false;
		}
		
		/*if(isNonImage==this.NO_IMAGE){
			oFCKeditor.ToolbarSet='ecologyNoImage';
		}else if(isNonImage==this.HtmlLayout_IMAGE){
			oFCKeditor.ToolbarSet='htmlLayout';
		}*/
		
		oFCKeditor.BasePath	= sBasePath;
		
		//�滻textarea
		//oFCKeditor.ReplaceTextarea();
			//oFCKeditor.Create();
		
		isNonImage="";
		if(isNonImage!=this.NO_IMAGE||true){
			//��ʼ������ͼƬ����
			
			if(isNonImage==this.WEB_IMAGE)isNonImage=true;
			else isNonImage=false;
			
			//_initUploadImage(formName,isNonImage);//���༭���е�ͼƬ�ϴ����ϵ���ǰForm��,Ĭ�ϴ�ͼƬ�������ϴ���
			
		}else{
			oFCKeditor.config.toolbarStartupExpanded = false
			toolbar = "simple";
		}
		
		
		oFCKeditor.config.toolbar=toolbar;
		oFCKeditor.on('instanceReady', function (event) {
			jQuery(".cke_editor").find("tr").css("height","0");
			_ckeditReader = true;
			_initUploadImage(formName,isNonImage,name)
			if (window.location.href.indexOf("/workflow/") != -1) {
				jQuery(".cke_skin_v2").css("display", "inline-block");
				jQuery(".cke_skin_v2").css("width", "98%");
				jQuery("#cke_remark").css("width", "98%");
			}
		})

			
		//��ɳ�ʼ��
		isInit=true;//��ǳ�ʼ�����
		displayAllmenu();
		displayPhraseselect();
		
		
	}
	
	/**
	 * ��ȡ�༭�����ݣ���ֵ��textarea
	 * @param ename textarea id
	 * @return
	 */
	function _updateContent(ename){
		if(!isInit)return;
		if(isEmpty(ename)){
			//ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
			_updateContentAll();
			return;
		}
		if(isTextMode)return;//�ı��༭ʱ������textArea������
		var oEditor = CKEDITOR.instances[ename];
		get(ename).value=oEditor.getData();
		//alert(get(ename).value)
	}
	/**
	 * ��ȡ���б༭�����ݣ���ֵ����Ӧ��textarea
	 * @return
	 */
	function _updateContentAll(){
		for(var i=0; i<CkeditorExt.editorName.length; i++){
			var tmpname = CkeditorExt.editorName[i];
			try{
				var oEditor = CKEDITOR.instances[ename];
				get(tmpname).value = oEditor.getData();
			}catch(e){}
		}
	}
	
	/**
	 * ��ȡ�༭��html����
	 * @param ename
	 * @return
	 */
	function _getHtml(ename){
		if(!isInit)return "";
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		this.updateContent(ename);
		return 	get(ename).value;
	}
	/**
	 * ��ȡ�༭���ı�����
	 * @param ename
	 * @return
	 */
	function _getText(ename){
		if(!isInit)return "";
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		this.updateContent(ename);
		var s=get(ename).value;		
		var div=document.createElement("div");
		div.innerHTML=s;
		return jQuery(div).text();
	}
	
	/**
	 * ��ȡ�༭���ı�����(��)
	 * @param ename
	 * @return
	 */
	function _getTextNew(ename){
		if(!isInit){
			return "";
		}
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		this.updateContent(ename);
		var s = get(ename).value;
		while(s.indexOf("</p>") >= 0){
			s = s.replace("</p>", "_=+=_");
		}
		while(s.indexOf("</P>") >= 0){
			s = s.replace("</P>", "_=+=_");
		}
		var div = document.createElement("div");
		div.innerHTML = s;
		s = jQuery(div).text();
		while(s.indexOf("_=+=_") >= 0){
			s = s.replace("_=+=_", "<br>");
		}
		var stmp = s.trim();
		while(stmp.indexOf("<br>") >= 0){
			stmp = stmp.replace("<br>", "");
			stmp = stmp.trim();
		}
		if(stmp == ""){
			s = "";
		}
		return s;
	}
	
	/**
	 * ���ñ༭������
	 * @param s
	 * @param ename
	 * @return
	 */
	function _setHtml(s,ename){
		if(!isInit)return;
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		if(isTextMode)	_switchEditMode(ename);//������ı��༭״̬���л�����.
		var oEditor = CKEDITOR.instances[ename];
		if(oEditor!=null && oEditor!=undefined){
			//LL for QC46153 start 2012/09/03
			//oEditor.setData(s);
			oEditor.setData(s,false,true);
			try{
				// "#cke_contents_remark iframe"��Զ��ǩ�������cheditor��ID�š����ֶ�����ʱ�򣬸�html��ʽ�����ı�
				// ���ֶ�����ֵʱ�򣬻��ظ�����ֵ���ȸ����ֶ�ֵ������ֵ���ֽ������е�ǩ�����Ҳ������ֵ������Ҫɾ����
				var ckeditIframe = "#cke_contents_" + ename + " iframe";
				jQuery(jQuery(ckeditIframe)[0].contentWindow.document.body).html(s);
			}catch(e){}
			//LL for QC46153 end 2012/09/03
		}
	}
	
	var currentImgType=2;//Ĭ���Ǳ����ļ�����
	var imgsCount=0;//Ĭ���ϴ���ͼƬ��Ϊ0
	
	/**
	 * ѡ��ͼƬ����
	 * @param o
	 * @return
	 */
	function _selectImageType(o,ename){
		if(currentImgType==o.value)return;
		get('imgUrlSpan_'+ename).style.display=(o.value==1)?'':'none';
		get('imgFileSpan_'+ename).style.display=(o.value==2)?'':'none';
		get('imgFileSpanTemp_'+ename).style.display=(o.value==2)?'block':'none';
		currentImgType=o.value;
	}
	
	//���Զ��� Ӣ��
	var en=new Array('',
		'URL can not be empty or illegal Address',
		'Please select a image file,addresses can not be empty!',
		'Are you confirm delete the image(Y/N)?',
		'You must be on WYSIWYG mode!',
		'example',
		'Insert image',
		'web image',
		'local image',
		'image url',
		'select image',
		'Ok',
		'Cancel',
		'Conversion to text edit mode will be lost format settings, to determine switch?',
		'Insert FlashVideo',
		'Incorrect Flash Video URL',
		'Uploading...',
		'Upload');
	
	// ���Զ��� ����
	var ch=new Array('',
		'URL��ַ����Ϊ�ջ�Ƿ���ַ',
		'��ѡ��ͼƬ�ļ�����ַ����Ϊ��!',
		'ȷ��ɾ����ͼƬ��(Y/N)?',
		'�����л������ӻ��༭״̬�ٲ���!',
		'����',
		'����ͼƬ',
		'����ͼƬ',
		'����ͼƬ',
		'ͼƬ��ַ',
		'ѡ��ͼƬ',
		'ȷ��',
		'ȡ��',
		'ת�����ı��༭�ᶪʧ��ʽ����,ȷ���л���(Y/N)?',
		'����Flash',
		'����ȷ��Flash��Ƶ��ʽ',
		'�ϴ���...',
		'�ϴ�');
	/**
	 * ��ȡ���Ա�ǩ
	 * @param i
	 * @return
	 */
	function _getLabel(i){
		return CkeditorExt.isEn?en[i]:ch[i];
	}
	
	/**
	 * ����Flash��Ƶ
	 * @param fUrl
	 * @return
	 */
	function _appendFlashVideo(fUrl){
		var s=new Array('<img class="editorFlashVideo" _flashUrl="',fUrl,'" src="/FCKEditor/FlashVideo.jpg" width="96" height="96"/>'
		).join("");
		_insertHtml(s);//��Ӵ������༭��
	/*		var iFVideo='<scr'+'ipt id="_initFVideo">initFlashVideo();</scr'+'ipt>';		
			var oDoc = FCKeditorAPI.GetInstance(CkeditorExt.editorName).EditorDocument;
	
			var jss=oDoc.getElementByTagName("script");
			alert("jss:"+jss.length);
			for(var i=0;i<jss.length;i++){
				alert(jss[i].id);
				if(jss[i].id=="_initFVideo"){jss[i].removeNode(true);break;}
			}
			if(oDoc.getElementById("_initFVideo")){
				oDoc.getElementById("_initFVideo").removeNode(true);
				alert('exist node!');
			}
				
			oDoc.focus();
			oDoc.execCommand("SelectAll");
			var rng=oDoc.selection.createRange();
			rng.collapse(false);
			rng.select();
			FCKeditorAPI.GetInstance(CkeditorExt.editorName).InsertHtml(iFVideo);
	*/		
		//var js=eDoc.createElement("span");
		//js.innerHTML='<script src="../../ab.js"/>';
		//eDoc.body.appendChild(js);
	}
	
	/**
	 * ����Flash����
	 * @param ename
	 * @return
	 */
	function _InsertFlashObject(ename){//����Flash����ִ��
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		var fUrl=get('flashUrl').value;
		if(get('isFlashVideoUrl').checked){
			_appendFlashVideo(fUrl);
		}else{
			var FCK = CKEDITOR.instances[ename];
			var win=window;
			oEmbed=(oEmbed==null)?document.createElement( 'EMBED' ):oEmbed;
			oEmbed.src=fUrl;
			oEmbed.wmode="transparent";
			oFakeImage=(oFakeImage==null)?win.FCKDocumentProcessor_CreateFakeImage('FCK__Flash',oEmbed):oFakeImage;
			oFakeImage.setAttribute('_fckflash', 'true',0) ;
			oFakeImage	= FCK.InsertElementAndGetIt(oFakeImage);
			win.FCKFlashProcessor.RefreshView(oFakeImage,oEmbed);
		}
	}
	
	/**
	 * �ж�url�Ϸ���
	 * @param val
	 * @return
	 */
	function _invalidUrl(val){
		return (val=='' || val.toLowerCase()=='http://' || val.substring(0,4).toLowerCase()!='http');
	}
	
	/**
	 * ����String���͵�endsWith����
	 */
	String.prototype.endsWith=function(suffix){
		var L1 = this.length ;
		var L2 = suffix.length ;
		if ( L2 > L1 )
			return false ;
		return ( L2 == 0 || this.substr( L1 - L2, L2 ) == suffix );
	}
	
	/**
	 * ����String���͵�trim����
	 */
	String.prototype.trim=function(){
		return this.replace(/^\s+|\s+$/g,"");
	}
	 var path,
     srcVal,
   
     FileReader = window.FileReader;
	 
	
	/**
	 * ȷ��
	 */
	function _Ok(ename){
		if(insertType==INSERT_FLASH){//ִ�в���Flash�Ĳ���
			var sUrl=get('flashUrl').value;
			if(_invalidUrl(sUrl)){
				alert(_getLabel(1));
			}else{
				if(get('isFlashVideoUrl').checked && !sUrl.toLowerCase().endsWith(".flv")){
					alert(_getLabel(15));
					return;
				}
				_InsertFlashObject();//�Ϸ���ַ����
				this.Cancel(ename);
			}
			return;	
		};//End if,insert falseh ===========================
		var imgTypeId=(currentImgType==1)?'imgUrl':'imgFile';
		var val="";

		var isFile=(imgTypeId=='imgFile');
		if(isFile){
			val=jQuery("#"+imgTypeId+"_"+ename).attr("url");
		}else{
			val=get(imgTypeId+"_"+ename).value;
		}
		
		var isFile=(imgTypeId=='imgFile');
		if(imgTypeId=='imgUrl' && _invalidUrl(val)){
			alert(_getLabel(1));return;
		}
		if(imgTypeId=='imgFile' && val==''){
			alert(_getLabel(2));return;
		}
		//encodeURIComponent
		var sHtml=null;
		if(isFile){
			sHtml=['<img alt="docimages_',imgsCount,'" src="',val,'"/>'];// id="',$('imgFile').name,'"
		}else{
			sHtml=['<img id="',_generateId(),'" alt="',val,'" src="',val,'"/>'];
			//ע��,�����������г���ķ���ͼƬ�Ǹ���<img alt= ,�������ﲻ�ܽ�alt����Ϊ��һ������.
		}
		jQuery('#uploadFileName_'+ename).html("");
		var isSucc=_insertHtml(sHtml.join('')+"&nbsp;&nbsp;&nbsp;",ename);
		
		if(!isSucc)return;
		if(isFile){//������ϴ��ļ�����Ҫ���ص�ǰ��������һ��ʾ
			//val="file:///"+val;
			imgId=" id='"+get('imgFile_'+ename).name+"' ";//�Ȼ�ȡimgName,��_newInputFile֮�������Ѿ����ı�
			_newInputFile(val);//�����µ�Input.file��
			get("docimages_num").value=""+imgsCount;
		}
		this.Cancel(ename);
		return false;
	}
	
	
	function _newInputFile(_v){
		return;
		imgsCount+=1;
		
		var o=get('imgFile');
		o.removeAttribute("id");
		var s=_getLabel(10)+'��<input style="" type="button" id="imgFile" name="docimages_0" size="30" value="'+_getLabel(17)+'"><span id="uploadFileName_'+ename+'"></span>';
		var newFile=jQuery(s);//ʹ��Input���ʱname�����޷���ֵ�������ַ���Html����
		jQuery('#imgFileSpan').html(s);
		//o.style.display='none';
		/************************/
		//s="<span>"+_v+"&nbsp;<a href='javascript:;' onclick='CkeditorExt.removeFile(this,\""+o.name+"\")'>ɾ��</a><br/></span>";
		//$('imgFileSpanTemp').innerHTML+=s;//����ɾ������
	}
	
	
	function _removeFile(obj,fileName,ename){
		if(!confirm(_getLabel(3)))return;
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		var oDoc = CKEDITOR.instances[ename].EditorDocument;
		if(oDoc.getElementById(fileName))
			oDoc.getElementById(fileName).removeNode(true);//ɾ���༭���ڵ�ͼƬ
		
		var files=document.getElementsByName(fileName);		
		if(files.length>0){
			files[0].removeNode(true);
		}
		obj.parentNode.removeNode(true);
	}
	
	/**
	 * �������ID���
	 * @return
	 */
	function _generateId(){
		var s="img_";
		return s+Math.ceil((Math.random()*8999+1000));
	}
	
	/**
	 * ����html����
	 * @param sHtml
	 * @param ename
	 * @return
	 */
	function _insertHtml(sHtml,ename){//��Html���뵽�༭����ȥ��
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		var isSucc=false;
		var oEditor = CKEDITOR.instances[ename]
		//var oEditor = CKeditorAPI.GetInstance(ename) ;
		// Check the active editing mode.
		//alert(oEditor.mode)
		if ( oEditor.mode == "wysiwyg"){
			oEditor.insertHtml(sHtml);
			isSucc = true;
		}else alert(_getLabel(4));
		return isSucc;
	}
	
	/**
	 * ȡ��
	 * @return
	 */
	function _Cancel(ename){
		get(this.id+"_"+ename).style.display='none';
		get(this.id+'_Image'+'_'+ename).style.display='none';
		get(this.id+'_Flash'+'_'+ename).style.display='none';
		get('imgUrl'+'_'+ename).value='http://';
		get('flashUrl').value='http://';
	}
	
	/**
	 * ��ʾ�Ի���
	 * @param sel 
	 * @return
	 */
	function _show(sel){
		
		if(get("insertObjectContainer_"+sel.name).style.display=='block')return;
		insertType=INSERT_IMAGE;
		get("insertObjectContainer_"+sel.name).firstChild.innerHTML=_getLabel(6);
		//this._sel=sel;
		get("insertObjectContainer_"+sel.name).style.display='block';
		get("insertObjectContainer"+'_Image_'+sel.name).style.display='block';
		get("insertObjectContainer"+'_Flash_'+sel.name).style.display='none';
	}
	
	/**
	 * ������Ƶ�ϴ�����
	 * @return
	 */
	function _InsertVideo(){
		var sUrl=prompt(_getLabel(5)+"��mms://www.weaver.com.cn/demo.wmv","http://");
		if(sUrl==undefined || sUrl=="");
		else{
			var w=300,h=200;
			var arHtml=new Array(
					"<span><object align='middle'  codebase='http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701' ",
					" classid='CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95'",
					" class='OBJECT'  id='MediaPlayer'  width='",w,"'  height='",h,"'  autostartvalue='-1' >",
					<!--img src=http://www.baidu.com/img/logo-yy.gif align=absbottom hspace=2 alt='::URL::' border=0-->
					"<param name='showstatusbar'  value='-1' ></param>",
					"<param name='filename'  value='",sUrl,"' ></param>",
					"<param name='autostart'  value='-1' ></param>",
					"<embed src='",sUrl,"'  type='application/x-oleobject' width='",w,"' height='",h,"'></embed>",
					"</object></span>");
			_insertHtml(arHtml.join(''));
		}
	}
	
	//css��ʽ����
	var sCssText=new Array('<style>\n','.editorImgWin{position:absolute; height: 168px;  width: 399px; background-color: #FFFFFF;font-size:9pt; border: 1px Solid #666;display:none;}\n',
	'.editorImgWin input label{display:inline;}\n',
	'</style>').join('');
	document.writeln(sCssText);
	
	/**
	 * �ļ��ϴ����ܳ�ʼ��
	 * @param formName
	 * @param isNonFile
	 * @param ename
	 * @return
	 */
	function _initUploadImage(formName,isNonFile,ename){
		//�����ж�
		isNonFile = false
		//alert(ename)
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		//alert(ename)
		if(isNonFile)currentImgType=1;
		var oFrm=get(formName);
		oFrm=(oFrm==null)?document.all[formName]:oFrm;
		if(!oFrm){alert('No formName is '+formName);return;}
		
		var pos=_getPosition(get("cke_"+ename));//+"___Frame"
		var s=new Array(
			'<div id="insertObjectContainer_'+ename+'" class="editorImgWin" style="left:',pos.x+200,'px; top:',pos.y+40,'px;">',
		'<div style="font-weight:bold;height:17px;font-size:10pt;padding-top:3px;padding-left:30px;background-color:#CCC;border-bottom:1px solid #666">',_getLabel(6),'</div><br />',
		'<span id="insertObjectContainer_Image_'+ename+'">',
		'<div style="padding-left:10px;padding-bottom:10px;',isNonFile?'display:none;':'','">',
		'<label for="imgTypeUrl"><input style="width:20px;" type="radio" name="imgType" onclick="CkeditorExt.selectImageType(this,\''+ename+'\')" id="imgTypeUrl_'+ename+'" value="1" ',isNonFile?' checked="checked" ':'',' />',_getLabel(7),'</label>',
		isNonFile?'':'<label for="imgTypeFile"><input style="width:20px;" onclick="CkeditorExt.selectImageType(this,\''+ename+'\')" type="radio" name="imgType" checked="checked" id="imgTypeFile_'+ename+'" value="2"/>'+_getLabel(8)+'</label>',
		'</div>',
		'<div style="padding-left:10px;">',
		'<span id="imgUrlSpan_'+ename+'" style="display:',isNonFile?'':'none','">'+_getLabel(9)+'��<input name="imgUrl_'+ename+'" value="http://" id="imgUrl" style="width:280px;" size="40"/></span>',
		isNonFile?'':'<span id="imgFileSpan_'+ename+'">'+_getLabel(10)+'��<input style="" type="button" id="imgFile_'+ename+'" name="docimages_0" size="30" value="'+_getLabel(17)+'"><span id="uploadFileName_'+ename+'"></span>',
		isNonFile?'':'<input type="hidden" name="docimages_num" id="docimages_num" value="0"/>',
		isNonFile?'':'</span>',
		isNonFile?'':'<span id="imgFileSpanTemp_'+ename+'"></span>',
		'</div>',
		'</span>',
		'<span style="display:none;padding-left:10px;" id="insertObjectContainer_Flash_'+ename+'">',
		'<label for="isFlashVideoUrl"><input style="width:20px;" type="checkbox" id="isFlashVideoUrl">�Ƿ�Flash��Ƶ(*.flv)</label><br>',
		'Flash��ַ:<input id="flashUrl" style="width:280px;" size="40">',
		'</span>',
		'<br/><div align="center"><button type="button" accesskey="O" id="okBtn" onclick="CkeditorExt.Ok(\''+ename+'\');" >',_getLabel(11),'(<u>O</u>)</button>&nbsp;&nbsp;&nbsp;',
		'<button type="button" onclick="CkeditorExt.Cancel(\''+ename+'\');" accesskey="C">',_getLabel(12),'(<u>C</u>)</button>',
		'</div></div>');
		var span=document.createElement("span");
		oFrm.appendChild(span);
		span.innerHTML=s.join('');
		var interval = window.setInterval(function(){  
		if(jQuery('#imgFile_'+ename).length>0){
			jQuery('#imgFile_'+ename).attr("url","")
			jQuery('#uploadFileName_'+ename).html("");
		 var button = jQuery('#imgFile_'+ename);  
		    new AjaxUpload(button,{  
		        action: '/kindeditor/jsp/upload_json.jsp?ename='+ename,   
		        name: 'imgFile_'+ename,  
		        data:{act:'uploadfile'},  
		        onSubmit : function(file, ext){  
		            if (!(ext && /^(jpg|png|gif)$/i.test(ext))){  
		                alert('�����ϴ�jpg|png|gif��ʽ��ͼƬ!');  
		                return false;  
		            }  
		            button.val(_getLabel(16));
		            jQuery("#okBtn").attr("disabled",true);  
		            this.disable();  
		            
		        },  
		        onComplete: function(file, response){  
		        	
		            var rs = eval("rs="+response);
		           
		            if(rs.error==0){
		            	jQuery('#imgFile_'+ename).attr("url",rs.url)		            	
		            	jQuery('#uploadFileName_'+ename).html(rs.name);
		            }else{
		            	jQuery('#imgFile_'+ename).attr("url","")
		            	jQuery('#uploadFileName_'+ename).html("");
		            }
		            window.clearInterval(interval);  
		            button.val(_getLabel(17));
		            this.enable();  
		            jQuery("#okBtn").attr("disabled",false); 
		                         
		        } 
		        
		    });
		    window.clearInterval(interval);  
		}
		
		},1000)
	}
	
	//�л��༭ģʽ
	function _switchEditMode(ename){
		
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		var oEditor = CKEDITOR.instances[ename];
		
		oEditor.execCommand("source");
		
	}
	
	
	var isTextMode=false;
	
	/**
	 * �л��ı�ģʽ
	 * @param a
	 * @param ename
	 * @return
	 */
	function _switchTextMode(a,ename){
		
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		if(isTextMode)return;
		var isSwitched=false;
		oEditor = CKEDITOR.instances[ename];
		oEditor.execCommand("source");
		isSwitched = true;
		return isSwitched;
	}
	
	/**
	 * ȫ��
	 * @param ename
	 * @return
	 */
	function _fullScreen(ename){
		if(!isInit)return;
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		var oEditor = CKEDITOR.instances[ename];
		oEditor.Commands.GetCommand("FitWindow").Execute();
	}
	
	/**
	 * ��ȡλ��
	 * @param o
	 * @return
	 */
	function _getPosition(o){
		
		var p1= o.offsetLeft,p2= o.offsetTop;
		
		/*while(o.offsetParent!=null&&o.tagName.toLowerCase()!="body"){
			o = o.offsetParent;
			
			p1 += o.offsetLeft;
			p2 += o.offsetTop;
			//alert(o.offsetParent==null)
		}*/
		p1=jQuery(o).offset().left;
		p2=jQuery(o).offset().top;
		return {"x":p1,"y":p2};
	}
	
	var INSERT_IMAGE=1;
	var INSERT_FLASH=2;
	var insertType=1;
	var oFakeImage=null;
	var oEmbed=null
	/**
	 * ������Ƶ�Ի���
	 */
	function _flashVideoDialog(){
		if(typeof(flvBrowserUrl)=="undefined")return;
		if(flvBrowserUrl!=null && flvBrowserUrl!=""){//������Ƶ�б��ļ���
			var sArgs="dialogWidth:600px,dialogHeight:450px";
			var ret=window.showModalDialog(flvBrowserUrl,"",sArgs);
			if(ret){
				_appendFlashVideo(ret);
			}
		}
	}
	
	/**
	 * ����Flash�Ի���
	 * @param ooFakeImage
	 * @param ooEmbed
	 * @return
	 */
	function _showFlashDialog(ooFakeImage,ooEmbed){
		if(get(this.id).style.display=='block')return;
		//��ʼ��
		oFakeImage=ooFakeImage;
		var oEmbed=ooEmbed;
		var fUrl=(oEmbed==null)?"http://":oEmbed.src;
		get('flashUrl').value=fUrl;
		/////////////////////////////////////////
		insertType=INSERT_FLASH;
		get(this.id).firstChild.innerHTML=_getLabel(14);
		get('isFlashVideoUrl').checked=false;
		get(this.id).style.display='block';
		get(this.id+'_Image').style.display='none';
		get(this.id+'_Flash').style.display='block';
	
	}
		
	var _chedkId=null;
	/**
	 * ��������
	 * @param arg0
	 * @param ename
	 * @return
	 */
	function _checkText(arg0,ename){
		
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		if(arg0=="INIT"){
			if(_chedkId==null){
				_chedkId="spadsdnId";
				var t=get(ename);
				t=(t==null)?document.all[ename]:t;
				t.insertAdjacentHTML("beforeBegin",'<span id="'+_chedkId+'"><img src="/images/BacoError.gif" align="absMiddle"></span>');
			}//���Ѿ����ڱ��ʱ����ֱ�Ӷ�ȡ��
			_doCheck(ename);
			return;	
		}else{
			if(typeof(arg0)=="string")_chedkId=arg0;//����Ѿ����ں�̾�ű�ǣ����¼
			else if(typeof(arg0)=="object")_chedkId=arg0.id;
			var txtCheckedNum = getTxtCheckedNum(ename);
			CkeditorExt.txtChecked[txtCheckedNum]=true;
		}
		
		_doCheck(ename);
	}
	
	/**
	 * ��������
	 * @param ename
	 * @return
	 */
	function _doCheck(ename){
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		var oFrm=get(ename+"___Frame");
		var sImg='<img src="/images/BacoError.gif" align="absMiddle">';
		var spanId=_chedkId;
		function setCheck(){
			//get(ename).value=CkeditorExt.getText(ename);
			if(get(ename).getAttribute("viewtype")==null){
				var html=CkeditorExt.getText(ename);
				if(html=="") {
					if (get(ename+"span")) {
						get(ename+"span").innerHTML=sImg;
					} else {
						get("remarkSpan").innerHTML=sImg;
					}
				} else {
					if (get(ename+"span")) {
						get(ename+"span").innerHTML="";
					} else {
						get("remarkSpan").innerHTML="";
					}
				}
			}else{
				if(get(ename).getAttribute("viewtype")=="1"){
					var html=CkeditorExt.getText(ename);
					if(html=="") {
						if (get(ename+"span")) {
							get(ename+"span").innerHTML=sImg;
						} else {
							get("remarkSpan").innerHTML=sImg;
						}
					} else {
						if (get(ename+"span")) {
							get(ename+"span").innerHTML="";
						} else {
							get("remarkSpan").innerHTML="";
						}
					}
				}
			}
		}
		var ckeditIframe = "#cke_contents_" + ename + " iframe";
		var ckeditRemarkIframe = "#cke_contents_remark iframe";
		ckeditBindEvent();
		function ckeditBindEvent() {
			if (!_ckeditReader) {
				setTimeout(ckeditBindEvent, 1000);	
				return;
			}
			jQuery(jQuery(ckeditIframe)[0].contentWindow.document.body).bind("focus",setCheck);
			jQuery(jQuery(ckeditIframe)[0].contentWindow.document.body).bind("blur",setCheck);
			
			//���CkEditot��Ӧ���ڷ�ǩ�������(�����̶���)����ǩ������򲻴��ڣ�����Ҫ���ǩ��������Ƿ���ڡ�
			if(jQuery(ckeditRemarkIframe)[0] != undefined){
				jQuery(jQuery(ckeditRemarkIframe)[0].contentWindow.document.body).bind("focus",setCheck);
				jQuery(jQuery(ckeditRemarkIframe)[0].contentWindow.document.body).bind("blur",setCheck);
			}
			
		}

		setCheck();
	}
		
	var isLoaded=false;//��Ǳ༭���Ƿ�װ�����
	/**
	 * �༭���������
	 * @param o
	 * @return
	 */
	function _loadComplete(o){
		isLoaded=true;
		var _txtchecked = getTxtChecked(o.Name);
		if(_txtchecked)_checkText("INIT", o.Name);//��ʼ����̾��
		if(_isExpand) o.ToolbarSet.Expand();
		else o.ToolbarSet.Collapse() ;
		if(typeof(CkeditorExt['complete'])=='function')CkeditorExt['complete'](o);
		/********************************************/		
		//$(o.Name+"___Frame").attachEvent("onblur",FCKeditorAPI.GetInstance(o.Name).updateContent);
	}
	/**
	 * ��������
	 * @param ename
	 * @return
	 */
	function getTxtChecked(ename){
		var i=0;
		for(i=0; i<CkeditorExt.editorName.length; i++){
			if(ename == CkeditorExt.editorName[i]){
				break;
			}
		}
		return CkeditorExt.txtChecked[i];
	}
	
	/**
	 * ��������
	 * @param ename
	 * @return
	 */
	function getTxtCheckedNum(ename){
		var i=0;
		for(i=0; i<CkeditorExt.editorName.length; i++){
			if(ename == CkeditorExt.editorName[i]){
				break;
			}
		}
		return i;
	}
	
	var _isExpand=true;
	/**
	 * չ����������������
	 * @param isExpand
	 * @param ename
	 * @return
	 */
	function _toolbarExpand(isExpand,ename){
		
		if(isEmpty(ename)) ename=CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		
		var oEditor = CKEDITOR.instances[ename];
		//alert(isExpand)
		
		oEditor.execCommand("toolbarCollapse");
		
	}
	
	/**
	 * ȥ��script�ű���frame�ű�
	 * @param s
	 * @return
	 */
	function _stripScripts(s){
		var script=new RegExp('(?:<script.*?>)((\n|\r|.)*?)(?:<\/script>)', 'img');
		//var object=new RegExp('(?:<object.*?>)((\n|\r|.)*?)(?:<\/object>)', 'img');
		var iframe=new RegExp('(?:<iframe.*?>)((\n|\r|.)*?)(?:<\/iframe>)', 'img');
		return s.replace(script,'').replace(iframe,'');//.replace(object,'');
	}
	
	/**
	 * �����¼��ű�
	 * @param s
	 * @return
	 */
	function _filterXss(s){
		var ename = CkeditorExt.editorName[CkeditorExt.editorName.length-1];
		if(ename != "layouttext"){
			var errReg1=/(<\w+ [^<>]*)onload='[^']*' ?([^<>]*\/?>)/img;
			var errReg2=/(<\w+ [^<>]*)onload="[^"]*" ?([^<>]*\/?>)/img;
			var loadReg1=/(<\w+ [^<>]*)onerror='[^']*' ?([^<>]*\/?>)/img;
			var loadReg2=/(<\w+ [^<>]*)onerror="[^"]*" ?([^<>]*\/?>)/img;
			var erpReg1=/(<\w+ [^<>]*)style='.+expression\(.*\)[^']*'([^<>]*\/?>)/img;
			var erpReg2=/(<\w+ [^<>]*)style=".+expression\(.*\)[^"]*"([^<>]*\/?>)/img;
			s=s.replace(errReg1,"$1$2").replace(loadReg1,"$1$2").replace(erpReg1,"$1$2");
			s=s.replace(errReg2,"$1$2").replace(loadReg2,"$1$2").replace(erpReg2,"$1$2");
			s=_stripScripts(s);
		}
		return s;
	}
	
	/**
	 * ���ñ༭����С
	 * @param w
	 * @param h
	 * @return
	 */
	function _resize(w,h){
		//jQuery("#cke_contents_"+"doccontent").css("height",divContentHeight-50);
		get(CkeditorExt.editorName+"___Frame").style.width=w;
		get(CkeditorExt.editorName+"___Frame").style.height=h;
	}
	
}());

/**
 * �༭����������¼�
 * @param editorInstance
 * @return
 */
function CKeditor_OnComplete(editorInstance)
{
	/*by alan
	 * �����㶨λ����һ�������,�����������ͣ����HTML�༭���� 
	 * for td:10409
	 */
	try {
		var i = 0;
		for(var j=0; j<document.getElementsByTagName('INPUT').length; j++) {
			var obj = document.getElementsByTagName('INPUT')[i];
			if(obj.type!='hidden' && obj.style.display!='none') {
				obj.focus();
				break;
			}
			i++;
		}
	}
	catch(e){}
	/*end by alan*/
	CkeditorExt._loadComplete(editorInstance);
}

var FCKEditorExt = CkeditorExt;

