/*
 * RoyalSlider  v8.1
 *
 * Copyright 2011-2012, Dmitry Semenov
 * 
 */
(function($) {

	function RoyalSlider(element, options) {
		this.slider = $(element);
		this._downEvent = "";
		this._moveEvent = "";
		this._upEvent = "";
		var self = this;	
				
		
		this.settings = $.extend({}, $.fn.royalSlider.defaults, options);
		
		
		this.isSlideshowRunning = false;
		this._slideshowHoverLastState = false;

		this._dragContainer = this.slider.find(".royalSlidesContainer");
		this._slidesWrapper = this._dragContainer.wrap('<div class="royalWrapper"/>').parent();
		this.slides = this._dragContainer.find(".royalSlide");

		this._preloader = "<p class='royalPreloader'></p>";	
		
		this._successfullyDragged = false;
		
		this._useWebkitTransition = false;
		if("ontouchstart" in window) {
			if(!this.settings.disableTranslate3d) {				
				if(('WebKitCSSMatrix' in window && 'm11' in new WebKitCSSMatrix())) {	
					this._dragContainer.css({"-webkit-transform-origin":"0 0", "-webkit-transform": "translateZ(0)"});
					this._useWebkitTransition = true;
				}
			}			
			this.hasTouch = true;
			this._downEvent = "touchstart.rs";
			this._moveEvent = "touchmove.rs";
			this._upEvent = "touchend.rs";
		} else {
			this.hasTouch = false;
			if(this.settings.dragUsingMouse) {
				this._downEvent = "mousedown.rs";
				this._moveEvent = "mousemove.rs";
				this._upEvent = "mouseup.rs";
			} else {
				// set cursor to auto if drag navigation is disabled
				this._dragContainer.addClass('auto-cursor');
			}
			
		}	
		
		if(this.hasTouch) {
			this.settings.directionNavAutoHide = false;
			this.settings.hideArrowOnLastSlide = true;
		}
		
		
		
		
		if ($.browser.msie  && parseInt($.browser.version, 10) <= 8) {
			this._isIE8 = true;
		} else {
			this._isIE8 = false;
		}
		
		this.slidesArr = [];
		var	slideObj,
			jqSlide,
			dataSRC,
			slideImg;

		// parse slides
		this.slides.each(function() {			
			jqSlide = $(this);			

			slideObj = {};
			slideObj.slide = jqSlide;

			// block all links inside slides 
			if(self.settings.blockLinksOnDrag) {				
				if(!this.hasTouch) {
					jqSlide.find('a').bind('click.rs', function(e) {					
						if(self._successfullyDragged) {						
							e.preventDefault();						
							return false;
						}						
					});
				} else {
					// Fix open link bug on touch devices
					var jqLinks = jqSlide.find('a');
					var jqLink;
					jqLinks.each(function() {
						jqLink = $(this);
						jqLink.data('royalhref', jqLink.attr('href'));
						jqLink.data('royaltarget', jqLink.attr('target'));
						jqLink.attr('href', '#');
						jqLink.bind('click', function(e) {							
							e.preventDefault();	
							if(self._successfullyDragged) {							
								return false;
							} else {
								var linkData = $(this).data('royalhref');							
								var linkTarget = $(this).data('royaltarget');						
								
								if(!linkTarget || linkTarget.toLowerCase() === '_self') {
									window.location.href = linkData;
								} else {
									window.open(linkData);
								}							
							}					
						});
					});		
				}					
			}
			
			// prevent dragging on all elements that have 'non-draggable' class
			if(self.settings.nonDraggableClassEnabled) {
				jqSlide.find('.non-draggable').bind(self._downEvent, function(e) {					
					self._successfullyDragged = false;	
					e.stopImmediatePropagation();
				});
			}
			
			
			dataSRC = jqSlide.attr("data-src");

			if(dataSRC == undefined || dataSRC == "" || dataSRC == "none") {
				slideObj.preload = false;				
			} else {
				slideObj.preload = true;						
				slideObj.preloadURL = dataSRC;
			}			

			if(self.settings.captionAnimationEnabled) {				
				slideObj.caption =  jqSlide.find(".royalCaption").css("display", "none");	
			}
			
			self.slidesArr.push(slideObj);
		});


		this._removeFadeAnimation = false;	
		if(this.settings.removeCaptionsOpacityInIE8) {
			if ($.browser.msie  && parseInt($.browser.version, 10) <= 8) {
				this._removeFadeAnimation = true;	
			}
		}

		if(this.settings.autoScaleSlider) {
			this.sliderScaleRatio = this.settings.autoScaleSliderHeight / this.settings.autoScaleSliderWidth ;
		}
				
				
		this.slider.css("overflow","visible");

		this.slideWidth = 0;
		


		this.slideshowTimer = '';
		this._alreadyStoped = false;

		this.numSlides = this.slides.length;

		this.currentSlideId = this.settings.startSlideIndex;
		this.lastSlideId = -1;

		this.isAnimating = true;
		
		this.wasSlideshowPlaying = false;
		
		// Used for checking back/forward drag direction
		this._currentDragPosition = 0;
		this._lastDragPosition = 0;	
		
		this._blockThumbnailsScroll = false;
		
		// Stores caption animations and clears after next slide is shown
		this._captionAnimateTimeouts = [];
		this._captionAnimateProperties = [];

		this._blockClickEvents = false;

		this._dragBlocked = false;
		
		this._startTime = 0;
		this._accelerationX = 0;
		
		this._tx = 0;
		this._startMouseX = 0;
		//used for detecting horizonal or vertical drag move
		this._startMouseY = 0;
		this._startPos = 0;

		this._isDragging = false;

		this._isHovering = false;
		
		
		// Setup transition
		if(this.settings.slideTransitionType === "fade") {
			if(this._useWebkitTransition || ('WebKitCSSMatrix' in window && 'm11' in new WebKitCSSMatrix())) {					
				this._animateCSS3Opacity = true;
			} else {
				this._animateCSS3Opacity = false;
			}
			this._fadeContainer = $("<div class='fade-container'></div>").appendTo(this._slidesWrapper);
		}
		
		
		// Setup Slideshow		
		if(this.settings.slideshowEnabled && this.settings.slideshowDelay > 0) {			
			if(!this.hasTouch && this.settings.slideshowPauseOnHover) {						
				this.slider.hover(
						function() {						
							self._isHovering = true;							
							self._stopSlideshow(true);
						},
						function() {							
							self._isHovering = false;							
							self._resumeSlideshow(true);
						}
				);				
			}
			this.slideshowEnabled = true;						
		} else {
			this.slideshowEnabled = false;
		}


		
		this._setGrabCursor();

		

		// Setup control nav (thumbs/bullets)
		if(this.settings.controlNavEnabled) {
			var _navigation;
			this._navigationContainer = '';
			
			var _thumbsAndArrowsContainer;

			if(!self.settings.controlNavThumbs) {				
				this._navigationContainer = $('<div class="royalControlNavOverflow"><div class="royalControlNavContainer"><div class="royalControlNavCenterer"></div></div></div>');
				_navigation = this._navigationContainer.find('.royalControlNavCenterer');		
			} else {
				this.slider.addClass('with-thumbs');
				if(self.settings.controlNavThumbsNavigation) {
					
					_thumbsAndArrowsContainer = $('<div class="thumbsAndArrowsContainer"></div>');
					
					this.thumbsArrowLeft = $("<a href='#' class='thumbsArrow left'></a>");
					this.thumbsArrowRight = $("<a href='#' class='thumbsArrow right'></a>");
					
					_thumbsAndArrowsContainer.append(this.thumbsArrowLeft);
					_thumbsAndArrowsContainer.append(this.thumbsArrowRight);
					
					// get size of thumbs scroller based on slider size and thumbs arrows size
					var thumbArrowLeftWidth = parseInt(this.thumbsArrowLeft.outerWidth(), 10);					
					//_navigationContainer = $('<div class="royalControlNavOverflow royalThumbs" style="left:'+thumbArrowLeftWidth+'px; width:'+(this.slider.width() - thumbArrowLeftWidth - parseInt(this.thumbsArrowRight.outerWidth(),10)) + 'px;"><div class="royalControlNavThumbsContainer"></div></div>');
					this._navigationContainer = $('<div class="royalControlNavOverflow royalThumbs"><div class="royalControlNavThumbsContainer"></div></div>');

					
					_navigation = this._navigationContainer.find('.royalControlNavThumbsContainer');	
				} else {
					this._navigationContainer = $('<div class="royalControlNavOverflow royalThumbs"><div class="royalControlNavContainer"><div class="royalControlNavCenterer"></div></div></div>');
					_navigation = this._navigationContainer.find(".royalControlNavCenterer");		
				}

			}

			var cSlideId = 0;			
			this.slides.each(function(index){	
				if(self.settings.controlNavThumbs) {								
					_navigation.append('<a href="#" class="royalThumb" style="background-image:url('+ $(this).attr("data-thumb") +')">' + (index + 1) + '</a>');
				} else {					
					_navigation.append('<a href="#">' + (index + 1) + '</a>');	
				}	
				cSlideId++;	
			});		

			this.navItems = _navigation.children();
			if(_thumbsAndArrowsContainer) {
				_thumbsAndArrowsContainer.append(this._navigationContainer);			
				this._slidesWrapper.after(_thumbsAndArrowsContainer);
			} else {
				this._slidesWrapper.after(this._navigationContainer);
			}
			

			// Thumbnails navigation
			if(self.settings.controlNavThumbs && self.settings.controlNavThumbsNavigation) {
				this._thumbsArrowLeftBlocked = true;
				this._thumbsArrowRightBlocked = false;

				this._thumbsNavContainer = _navigation;
				
				if(this._useWebkitTransition) {
					this._thumbsNavContainer.css({'-webkit-transition-duration': this.settings.controlNavThumbsSpeed + "ms",
						'-webkit-transition-property': '-webkit-transform',
						'-webkit-transition-timing-function': "ease-in-out"
					});
				}
				
					
				

				this._numThumbItems = cSlideId;
				
				var firstItem = this.navItems.eq(0);
				this._outerThumbWidth = firstItem.outerWidth(true);
				this._thumbsTotalWidth = this._outerThumbWidth * this._numThumbItems;
				
				

				this._thumbsNavContainer.css("width",this._thumbsTotalWidth);
				this._thumbsSpacing = parseInt(firstItem.css("marginRight"), 10);
				this._thumbsTotalWidth -= this._thumbsSpacing;
				this._currThumbsX = 0;
				
				this._recalculateThumbsScroller();
				
				this.thumbsArrowLeft.click(function(e){
					e.preventDefault();
					if(!self._thumbsArrowLeftBlocked) {
						self._animateThumbs(self._currThumbsX + self._thumbsContainerWidth + self._thumbsSpacing);		
					}									
				});
				this.thumbsArrowRight.click(function(e){
					e.preventDefault();
					if(!self._thumbsArrowRightBlocked) {
						self._animateThumbs(self._currThumbsX - self._thumbsContainerWidth - self._thumbsSpacing);					
					}						
				});
			}
			this._updateControlNav();
		}



		//Direction navigation (arrows)
		if(this.settings.directionNavEnabled) {	
			this._slidesWrapper.after("<a href='#' class='arrow left'/>");
			this._slidesWrapper.after("<a href='#' class='arrow right'/>");


			this.arrowLeft = this.slider.find("a.arrow.left");
			this.arrowRight = this.slider.find("a.arrow.right");

			if(this.arrowLeft.length < 1 || this.arrowRight.length < 1) {
				this.settings.directionNavEnabled = false;
			} else if(this.settings.directionNavAutoHide) {
				this.arrowLeft.hide();
				this.arrowRight.hide();

				this.slider.one("mousemove.arrowshover",function() {
					self.arrowLeft.fadeIn("fast");
					self.arrowRight.fadeIn("fast");					
				});


				this.slider.hover(
						function() {
							self.arrowLeft.fadeIn("fast");
							self.arrowRight.fadeIn("fast");
						},
						function() {
							self.arrowLeft.fadeOut("fast");
							self.arrowRight.fadeOut("fast");				
						}
				);	
			}	
			this._updateDirectionNav();
		}



		// Manage window resize event with 100ms delay
		this.sliderWidth = 0;
		this.sliderHeight = 0;
		var resizeTimer;
		this._resizeEvent = 'onorientationchange' in window ? 'orientationchange.royalslider' : 'resize.royalslider';
		$(window).bind(this._resizeEvent, function() {		
			if (resizeTimer) {
				clearTimeout(resizeTimer);			
			}				
			resizeTimer = setTimeout(function() { self.updateSliderSize(); }, 100);					
		});
		this.updateSliderSize();

		this.settings.beforeLoadStart.call(this);

		
		
		// loading screen handling	
		var firstSlide = this.slidesArr[this.currentSlideId];	
		
		if(this.currentSlideId != 0) {
			if(!this._useWebkitTransition) {
				this._dragContainer.css({ 'left':-this.currentSlideId * this.slideWidth});
			} else {
				this._dragContainer.css({ '-webkit-transition-duration':'0', '-webkit-transition-property': 'none' });
				this._dragContainer.css({ '-webkit-transform': 'translate3d(' + -this.currentSlideId * this.slideWidth + 'px, 0, 0)' });
			}
		}	
		
		
		if(this.settings.welcomeScreenEnabled) {
			// gets url of image to preload (background-image of slide)
			function hideWelcomeScreen(preloadNearby) {	

				self.settings.loadingComplete.call(self);
				
				if(preloadNearby && self.settings.preloadNearbyImages) {
					self._preloadNearbyImages(self.currentSlideId);				
				}		

				self.slider.find('.royalLoadingScreen').fadeOut(self.settings.welcomeScreenShowSpeed);	
				setTimeout(function(){ self._startSlider(); }, self.settings.welcomeScreenShowSpeed + 100);		
			}


			if(firstSlide.preload) {
				// lazy-load image		
				this._preloadNearbyImages(this.currentSlideId, function(){						
					hideWelcomeScreen( false );								
				});			

			} else {				
				slideImg = firstSlide.slide.find( 'img.royalImage' )[0];
				
				
				if(slideImg) {	
					if(this._isImageLoaded(slideImg)) {
						hideWelcomeScreen( true );			
						$(slideImg).css('opacity',0);
						$(slideImg).animate({"opacity":1}, "fast");
					} else {						
						// create new image and wait it to load (IE bug)
						$(slideImg).css('opacity',0);
						$('<img />').load( function(){							
							hideWelcomeScreen( true );								
							$(slideImg).animate({"opacity":1}, "fast");
						}).attr('src', slideImg.src);						
					}
				}
				else {
					// no image tag, just start slider					
					hideWelcomeScreen( true );						
				}				
			}			
		} else {	
			if(firstSlide.preload) {				
				// lazy-load image					
				this._preloadImage(firstSlide, function(){		
					self.settings.loadingComplete.call(self);
					if(self.settings.preloadNearbyImages) {	
						self._preloadNearbyImages(self.currentSlideId);
					}					
				});
			} else {				
				slideImg = firstSlide.slide.find( 'img.royalImage' )[0];				
				if(slideImg) {	
					if(this._isImageLoaded(slideImg)) {	
						$(slideImg).css('opacity',0).animate({"opacity":1}, "fast");						
					} else {	
						$(slideImg).css('opacity',0);
						$('<img />').load( function(){
							$(slideImg).animate({"opacity":1}, "fast");							
						}).attr('src', slideImg.src);						
					}
				}				
				this.settings.loadingComplete.call(this);
			}
			setTimeout(function(){ self._startSlider(); },100);	
		}


	} /* RoyalSlider Constructor End */
	/* -------------------------------------RoyalSlider Prototype------------------------------------------------------*/
	RoyalSlider.prototype = {
			/**
			 * Move to slide with specified id. 
			 * @id 		Slide id (integer).
			 * @silent  Go to slide without animation
			 * @fromNav Used for advanced thumbs navigation (boolean). Don't touch it ;)
			 */			 
			goTo:function(id, silent, fromNav, fromTouch, customSpeed) {	
				
				if(!this.isAnimating) {
					this.isAnimating = true;
					var self = this;
					
					this.lastSlideId = this.currentSlideId;
					this.currentSlideId = id;	

					
					this._dragBlocked = true;						
					
					

					this._blockClickEvents = true;
					
					if(this.lastSlideId != id) {
						this._updateControlNav(fromNav);
						this._preloadNearbyImages(id);												
					}

					this._updateDirectionNav();

					this.settings.beforeSlideChange.call(this);
					
					if(this.slideshowEnabled && this.slideshowTimer) {		
						this.wasSlideshowPlaying = true;
						this._stopSlideshow();
					}
										
					
					// Animate slide
					var slideAnimSpeed = !silent ? this.settings.slideTransitionSpeed : 0;
					
					
					if(fromTouch || silent || this.settings.slideTransitionType === "move") {
						var easing;
						if(customSpeed > 0) {
							slideAnimSpeed = customSpeed;						
						} else {						
							easing = this.settings.slideTransitionEasing;
						}
						
						if(!this._useWebkitTransition) {
							if(parseInt(this._dragContainer.css("left"), 10) !== -this.currentSlideId * this.slideWidth){
								this._dragContainer.animate(
										{left: -this.currentSlideId * this.slideWidth}, 
										slideAnimSpeed,
										(customSpeed > 0 ? "easeOutSine" : this.settings.slideTransitionEasing), 
										function(){self._onSlideAnimationComplete();
								});
							} else {						
								this._onSlideAnimationComplete();
							}
	 						
						} else {						
							if(this._getWebkitTransformX() !==  -this.currentSlideId * this.slideWidth) {					
								
								this._dragContainer.bind("webkitTransitionEnd.rs", function(e) {								
									if(e.target == self._dragContainer.get(0)) {	
										self._dragContainer.unbind("webkitTransitionEnd.rs");
										self._onSlideAnimationComplete();		
										
									}					
								});
								
								this._dragContainer.css({
									'-webkit-transition-duration': slideAnimSpeed + "ms",
									'-webkit-transition-property': '-webkit-transform',									
									'-webkit-transition-timing-function': (customSpeed > 0 ? "ease-out" : "ease-in-out"), 
									'-webkit-transform': 'translate3d(' + -this.currentSlideId * this.slideWidth + 'px, 0, 0)'								
								});								
							} else {						
								this._onSlideAnimationComplete();
							}						
						}
					} else {		
						// Fade transition
						var currSlide = this.slidesArr[this.lastSlideId].slide;						
						var newSlide = currSlide.clone().appendTo(this._fadeContainer);						
						
						if(!this._animateCSS3Opacity) {		
						
						 	this._dragContainer.css({left: -this.currentSlideId * this.slideWidth});									
							newSlide.animate({opacity:0}, slideAnimSpeed, this.settings.slideTransitionEasing, function() {
								newSlide.remove();
								self._onSlideAnimationComplete();
							});							
						} else {
							if(!this._useWebkitTransition) {
								this._dragContainer.css({left: -this.currentSlideId * this.slideWidth});			
							} else {
								this._dragContainer.css({
									'-webkit-transition-duration': '0',															
									'-webkit-transform': 'translate3d(' + -this.currentSlideId * this.slideWidth + 'px, 0, 0)',
									'opacity':'1'
								});
							}
							
							setTimeout(function(){								
								newSlide.bind("webkitTransitionEnd.rs", function(e) {								
									if(e.target == newSlide.get(0)) {	
										newSlide.unbind("webkitTransitionEnd.rs");
										newSlide.remove();
										self._onSlideAnimationComplete();									
									}								
								});							
								newSlide.css({
									'-webkit-transition-duration': slideAnimSpeed + "ms",
									'-webkit-transition-property': 'opacity',
									'-webkit-transition-timing-function': "ease-in-out"
								});	
								newSlide.css('opacity', 0);
							}, 100);							
						}
						
					}
				}
			},	
			//go to slide without animation
			goToSilent:function(id) {
				this.goTo(id, true);
			},
			// go to prev slide (cyclic)
			prev:function() {
				if(this.currentSlideId <= 0) { 
					this.goTo(this.numSlides - 1);				
				} else {
					this._moveSlideLeft();
				}	
			},
			// go to next slide (cyclic)
			next:function() {
				//go from last to first
				if(this.currentSlideId >= this.numSlides - 1) {				
					this.goTo(0);		
				} else {
					this._moveSlideRight();
				}	
			},
			// handling browser resize	onresize
			updateSliderSize:function() {
				var self = this;			
				
				var newWidth;
				var newHeight;
				
				if(this.settings.autoScaleSlider) {
					newWidth = this.slider.width();
					if(newWidth != this.sliderWidth) {
						this.slider.css("height", newWidth * this.sliderScaleRatio);
					}		
				}
				newWidth = this.slider.width();
				newHeight = this.slider.height();
				
				
				if(newWidth != this.sliderWidth || newHeight != this.sliderHeight) {
				
					this.sliderWidth = newWidth;
					this.sliderHeight = newHeight;
					
					this.slideWidth = this.sliderWidth + this.settings.slideSpacing;					
					
					var arLen=this.slidesArr.length;
					var _currItem, _currImg;					
	
					for ( var i=0, len=arLen; i<len; ++i ){
						_currItem = this.slidesArr[i];
						_currImg = _currItem.slide.find("img.royalImage").eq(0);
						if(_currImg && _currItem.preload == false) {							
							this._scaleImage(_currImg, this.sliderWidth, this.sliderHeight);						
						}
						
						if(this.settings.slideSpacing > 0 && i < arLen - 1) {							
							_currItem.slide.css("cssText", "margin-right:"+ this.settings.slideSpacing +"px !important;");							
						}
						
						_currItem.slide.css({height: self.sliderHeight, width: self.sliderWidth});
					}
					if(!this._useWebkitTransition) {
						this._dragContainer.css({"left":-this.currentSlideId * this.slideWidth, width:this.slideWidth * this.numSlides});
					} else {
						if(!this._dragBlocked) {
							this._dragContainer.css({'-webkit-transition-duration':'0',
								'-webkit-transition-property': 'none'});
							this._dragContainer.css({							
								'-webkit-transform': 'translate3d(' + -this.currentSlideId * this.slideWidth + 'px, 0, 0)', 
								width:this.slideWidth * this.numSlides
							});
						}
						
					}
					
					if(this.settings.controlNavThumbs && this.settings.controlNavThumbsNavigation) {
						this._recalculateThumbsScroller();						
					}
					
				}

			},
			stopSlideshow: function() {				
				this._stopSlideshow();
				this.slideshowEnabled = false;
				this.wasSlideshowPlaying = false;				
			},
			resumeSlideshow: function() {
				this.slideshowEnabled = true;
				if(!this.wasSlideshowPlaying) {
					this._resumeSlideshow();
				}				
			},
			// destroy slider instance
			destroy: function() {
				this._stopSlideshow();
				this._dragContainer.unbind(this._downEvent);
				$(document).unbind(this._moveEvent).unbind(this._upEvent);	
				$(window).unbind(this._resizeEvent);
				if(this.settings.keyboardNavEnabled) {
					$(document).unbind("keydown.rs");
				}	
				this.slider.remove();
				
				delete this.slider;
			},
			_preloadNearbyImages: function(id, firstLoadedCallback) {
				if(this.settings.preloadNearbyImages) {
					var self = this;				
					this._preloadImage(this.slidesArr[id], function() {	
						if(firstLoadedCallback) {
							firstLoadedCallback.call();
						}
						
						self._preloadImage(self.slidesArr[id + 1], function() {
							self._preloadImage(self.slidesArr[id - 1]);	
						});	
					});
				} else {				
					this._preloadImage(this.slidesArr[id], firstLoadedCallback);	
				}
			},
			_updateControlNav:function(fromNav) {
				if(this.settings.controlNavEnabled) {					
					this.navItems.eq(this.lastSlideId).removeClass('current');

					this.navItems.eq(this.currentSlideId).addClass("current");

					// thumbnails scroller navigation
					if(this.settings.controlNavThumbs && this.settings.controlNavThumbsNavigation) {					
						var _thumbX = this.navItems.eq(this.currentSlideId).position().left;					
						var _currThumbVisiblePosition = _thumbX - Math.abs(this._currThumbsX);					
						if(_currThumbVisiblePosition > this._thumbsContainerWidth - this._outerThumbWidth * 2 - 1 - this._thumbsSpacing) {
							if(!fromNav) {
								this._animateThumbs(-_thumbX + this._outerThumbWidth);
							} else {
								this._animateThumbs(-_thumbX - this._outerThumbWidth * 2 + this._thumbsContainerWidth + this._thumbsSpacing);
							}								
						} else if (_currThumbVisiblePosition < this._outerThumbWidth * 2 - 1) {								
							if(!fromNav) {
								this._animateThumbs(-_thumbX - this._outerThumbWidth * 2 + this._thumbsContainerWidth + this._thumbsSpacing);
							} else {
								this._animateThumbs(-_thumbX + this._outerThumbWidth);
							}								
						} 
					}
				}
			},
			_updateDirectionNav:function() {
				if(this.settings.directionNavEnabled)
				{
					if(this.settings.hideArrowOnLastSlide) {						
						if(this.currentSlideId == 0) {
							this._arrowLeftBlocked = true;
							this.arrowLeft.addClass("disabled");	
							if(this._arrowRightBlocked) {
								this._arrowRightBlocked = false;
								this.arrowRight.removeClass("disabled");
							}
						} else if(this.currentSlideId == this.numSlides - 1) {
							this._arrowRightBlocked = true;							
							this.arrowRight.addClass("disabled");	
							if(this._arrowLeftBlocked) {
								this._arrowLeftBlocked = false;
								this.arrowLeft.removeClass("disabled");		
							}
						} else {
							if(this._arrowLeftBlocked) {								
								this._arrowLeftBlocked = false;
								this.arrowLeft.removeClass("disabled");				
							} else if(this._arrowRightBlocked) {								
								this._arrowRightBlocked = false;
								this.arrowRight.removeClass("disabled");		
							}
						}
					}
				}
			},
 			_resumeSlideshow: function(playedFromHover){
 				if(this.slideshowEnabled) {
 					var self = this;
 	 				if(!this.slideshowTimer) {
 	 					this.slideshowTimer = setInterval(function() { self.next(); }, this.settings.slideshowDelay);
 	 				}
 				}	
			},	
			_stopSlideshow: function(stoppedFromHover){
				if(this.slideshowTimer) {					
					clearInterval(this.slideshowTimer);
					this.slideshowTimer = '';
				}								
			},				
			_preloadImage: function(slideObj, completeCallback) {				
				if(slideObj) {
					if(slideObj.preload) {
						var self = this;
						var img = new Image();
						var jqImg = $(img);
						jqImg.css("opacity",0);
						
						
						jqImg.addClass("royalImage");
						slideObj.slide.prepend(jqImg);		
						// add preloader
						slideObj.slide.prepend(this._preloader);					
						slideObj.preload = false;
						
						jqImg.load(function() {			
							
							self._scaleImage(jqImg, self.sliderWidth, self.sliderHeight);
							
							jqImg.animate({"opacity":1}, 300, function() {
								slideObj.slide.find(".royalPreloader").remove();								
							});
							
							
							if(completeCallback) {
								completeCallback.call();		
							}											
						}).attr('src', slideObj.preloadURL);
						
					} else {
						if(completeCallback) {
							completeCallback.call();		
						}				
					}
				} else {
					if(completeCallback) {
						completeCallback.call();		
					}
				}
			},
			// calculate thumbnails scroller size on start and on window resize
			_recalculateThumbsScroller:function() {				
				this._thumbsContainerWidth = parseInt(this._navigationContainer.width(), 10);				
				this._minThumbsX = -(this._thumbsTotalWidth - this._thumbsContainerWidth);
				
				// move to 0 position, if thumbs width is less then container width
				if(this._thumbsContainerWidth >= this._thumbsTotalWidth) {				
					this._thumbsArrowRightBlocked = true;
					this._thumbsArrowLeftBlocked = true;
					this.thumbsArrowRight.addClass("disabled");
					this.thumbsArrowLeft.addClass("disabled");
					this._blockThumbnailsScroll = true;
					this._setThumbScrollerPosition(0);					
				} else {
					this._blockThumbnailsScroll = false;				
					var _thumbX = this.navItems.eq(this.currentSlideId).position().left;				
					this._animateThumbs(-_thumbX + this._outerThumbWidth);
				}								
			},
			// animate thumbnails scroller
			_animateThumbs:function(newPosition) {	
				if(!this._blockThumbnailsScroll && newPosition != this._currThumbsX) {
					if(newPosition <= this._minThumbsX) {
					
						newPosition = this._minThumbsX;
						this._thumbsArrowLeftBlocked = false;
						this._thumbsArrowRightBlocked = true;
						this.thumbsArrowRight.addClass("disabled");
						this.thumbsArrowLeft.removeClass("disabled");
					} else if(newPosition >= 0) {
						
						newPosition = 0;
						this._thumbsArrowLeftBlocked = true;
						this._thumbsArrowRightBlocked = false;
						this.thumbsArrowLeft.addClass("disabled");
						this.thumbsArrowRight.removeClass("disabled");
					} else {
						if(this._thumbsArrowLeftBlocked) {
							this._thumbsArrowLeftBlocked = false;
							this.thumbsArrowLeft.removeClass("disabled");
						} 
						if (this._thumbsArrowRightBlocked) {
							this._thumbsArrowRightBlocked = false;
							this.thumbsArrowRight.removeClass("disabled");
						}
					}
					this._setThumbScrollerPosition(newPosition);
					
					this._currThumbsX = newPosition;
				}
			},
			_setThumbScrollerPosition:function(newPosition) {
				if(!this._useWebkitTransition) {
					this._thumbsNavContainer.animate(
						{left: newPosition}, 
						this.settings.controlNavThumbsSpeed,
						this.settings.controlNavThumbsEasing);
				} else {	
					this._thumbsNavContainer.css({'-webkit-transform': 'translate3d(' + newPosition + 'px, 0, 0)'}); 
				}
			},
			_startSlider:function() {
				var self = this;
				this.slider.find(".royalLoadingScreen").remove();

				if(this.settings.controlNavEnabled) {
					this.navItems.bind("click", function(e){ 
						e.preventDefault(); 
						if(!self._blockClickEvents) {
							self._onNavItemClick(e);
						}							
					});
				}

				if(this.settings.directionNavEnabled) {
					this.arrowRight.click(function(e) {
						e.preventDefault();	
						if(!self._arrowRightBlocked && !self._blockClickEvents) {
							self.next();
						}							
					});

					this.arrowLeft.click(function(e) {
						e.preventDefault();
						if(!self._arrowLeftBlocked && !self._blockClickEvents) {
							self.prev();
						}							
					});	
				}
				// keyboard nav
				if(this.settings.keyboardNavEnabled) {
					$(document).bind("keydown.rs", function(e) {
						if(!self._blockClickEvents) {
							if (e.keyCode === 37) {
								// left
								self.prev();
							}
							else if (e.keyCode === 39) {
								// right
								self.next();
							}
						}
					});
				}
				this.wasSlideshowPlaying = true;
				this._onSlideAnimationComplete();
							
				this._dragContainer.bind(this._downEvent, function(e) { 			
					if(!self._dragBlocked) {
						self._onDragStart(e); 	
					} else if(!self.hasTouch) {							
						e.preventDefault();
					}								
				});	

				if(this.slideshowEnabled && !this.settings.slideshowAutoStart) {
					this._stopSlideshow();
				}

				this.settings.allComplete.call(this);
			},
			_setGrabCursor:function() {				
				this._dragContainer.removeClass('grabbing-cursor');
				this._dragContainer.addClass('grab-cursor');				
			},
			_setGrabbingCursor:function() {			
				this._dragContainer.removeClass('grab-cursor');
				this._dragContainer.addClass('grabbing-cursor');				
			},
			_moveSlideRight:function(fromTouch, customSpeed) {			
				if(this.currentSlideId < this.numSlides - 1) {
					this.goTo(this.currentSlideId+1, false, false, fromTouch, customSpeed);			
				} else {
					this.goTo(this.currentSlideId, false, false, fromTouch, customSpeed);			
				}		
			},
			_moveSlideLeft:function(fromTouch, customSpeed) {
				if(this.currentSlideId > 0) { 
					this.goTo(this.currentSlideId-1, false, false, fromTouch, customSpeed);			
				} else {
					this.goTo(this.currentSlideId, false, false, fromTouch, customSpeed);			
				}			
			},			
			_onNavItemClick:function(e) {		
				this.goTo($(e.currentTarget).index(), false , true);	
			},
			// Thanks to @benpbarnett
			_getWebkitTransformX:function(){
				var transform = window.getComputedStyle(this._dragContainer.get(0), null).getPropertyValue("-webkit-transform");				
				var explodedMatrix = transform.replace(/^matrix\(/i, '').split(/, |\)$/g);				
				return parseInt(explodedMatrix[4], 10);
			},
			// Start dragging the slide
			_onDragStart:function(e) {
				
				if(!this._isDragging) {					
					var point;
					if(this.hasTouch) {
						this._lockYAxis = false;
						//parsing touch event
						var currTouches = e.originalEvent.touches;
						if(currTouches && currTouches.length > 0) {
							point = currTouches[0];
						}					
						else {	
							return false;						
						}
					} else {
						point = e;								
						e.preventDefault();						
					}
					if(this.slideshowEnabled) {					
						if(this.slideshowTimer) {
							this.wasSlideshowPlaying = true;
							this._stopSlideshow();							
						} else {
							this.wasSlideshowPlaying = false;
						}
					}


					this._setGrabbingCursor();			
					this._isDragging = true;
					var self = this;
					if(this._useWebkitTransition) {
						self._dragContainer.css({'-webkit-transition-duration':'0', '-webkit-transition-property': 'none'});
					}
					$(document).bind(this._moveEvent, function(e) { self._onDragMove(e); });
					$(document).bind(this._upEvent, function(e) { self._onDragRelease(e); });		

					if(!this._useWebkitTransition) {
						this._startPos = this._tx = parseInt(this._dragContainer.css("left"), 10);	
					} else {						
						this._startPos = this._tx =  this._getWebkitTransformX();						
					}
					this._successfullyDragged = false;
					this._accelerationX = this._tx;
					this._startTime = (e.timeStamp || new Date().getTime());
					this._startMouseX = point.clientX;
					this._startMouseY = point.clientY;
				}
				return false;	
			},				
			_onDragMove:function(e) {	
				
				var point;
				if(this.hasTouch) {
					if(this._lockYAxis) {
						return false;
					}				
					
					var touches = e.originalEvent.touches;
					// If touches more then one, so stop sliding and allow browser do default action
					
					if(touches.length > 1) {
						return false;
					}
					
					point = touches[0];	
					// If drag direction on mobile is vertical, so stop sliding and allow browser to scroll				
					if(Math.abs(point.clientY - this._startMouseY) > Math.abs(point.clientX - this._startMouseX) + 3) {
						if(this.settings.lockAxis) {
							this._lockYAxis = true;
						}						
						return false;
					}
				
					e.preventDefault();				
				} else {
					point = e;
					e.preventDefault();		
				}

				// Helps find last direction of drag move
				this._lastDragPosition = this._currentDragPosition;
				var distance = point.clientX - this._startMouseX;
				if(this._lastDragPosition != distance) {
					this._currentDragPosition = distance;
				}

				if(distance != 0)
				{			
					if(this.currentSlideId == 0) {			
						if(distance > 0) {
							distance = Math.sqrt(distance) * 5;
						}			
					} else if(this.currentSlideId == (this.numSlides -1)) {		
						if(distance < 0) {
							distance = -Math.sqrt(-distance) * 5;
						}	
					}
					if(!this._useWebkitTransition) {
						this._dragContainer.css("left", this._tx + distance);		
					} else {
						this._dragContainer.css({'-webkit-transform': 'translate3d(' +  (this._tx + distance) + 'px, 0, 0)'}); 
					}
				}	
				
				var timeStamp = (e.timeStamp || new Date().getTime());
				if (timeStamp - this._startTime > 350) {
					this._startTime = timeStamp;
					this._accelerationX = this._tx + distance;						
				}
				
				 	
				return false;		
			},
			_onDragRelease:function(e) {
                               	
				if(this._isDragging) {	
					var self = this;
					this._isDragging = false;			
					this._setGrabCursor();
					if(!this._useWebkitTransition) {
						this.endPos = parseInt(this._dragContainer.css("left"), 10);
					} else {
						this.endPos = this._getWebkitTransformX();
					}
					
					this.isdrag = false;

					$(document).unbind(this._moveEvent).unbind(this._upEvent);					

					
					if(this.slideshowEnabled) {
						if(this.wasSlideshowPlaying) {		
							if(!this._isHovering) {
								this._resumeSlideshow();
							}						
							this.wasSlideshowPlaying = false;						
						}
					}
					
					
					if(this.endPos == this._startPos) {						
						this._successfullyDragged = false;
						return;
					} else {
						this._successfullyDragged = true;
					}
					
					
					
					var dist = (this._accelerationX - this.endPos);		
					var duration =  Math.max(40, (e.timeStamp || new Date().getTime()) - this._startTime);
					// For nav speed calculation F=ma :)
					var v0 = Math.abs(dist) / duration;	
					
					
					
					var newDist = this.slideWidth - Math.abs(this._startPos - this.endPos);
					var newDuration = Math.max((newDist * 1.08) / v0, 200);
					newDuration = Math.min(newDuration, 600);
		
					function returnToCurrent() {						
						newDist = Math.abs(self._startPos - self.endPos);
						newDuration = Math.max((newDist * 1.08) / v0, 200);
						newDuration = Math.min(newDuration, 500);
						self.goTo(self.currentSlideId, false, false, true, newDuration );
					}
					// calculate slide move direction
					if(this._startPos - this.settings.minSlideOffset > this.endPos) {		

						if(this._lastDragPosition < this._currentDragPosition) {		
							returnToCurrent();
							return false;					
						}

						this._moveSlideRight(true, newDuration);
					} else if(this._startPos + this.settings.minSlideOffset < this.endPos) {		
						if(this._lastDragPosition > this._currentDragPosition) {			
							returnToCurrent();
							return false;
						}
						this._moveSlideLeft(true, newDuration);

					} else {
						returnToCurrent();
					}
				}

				return false;
			},		
			// Slide animation complete handler
			_onSlideAnimationComplete:function() {	
				
				var self = this;
				
				if(this.slideshowEnabled) {
					if(this.wasSlideshowPlaying) {		
						if(!this._isHovering) {
							this._resumeSlideshow();
						}						
						this.wasSlideshowPlaying = false;						
					}
				}
				
				this._blockClickEvents = false;
				this._dragBlocked = false;

				if(this.settings.captionAnimationEnabled && this.lastSlideId != this.currentSlideId) {
					// hide last slide caption
					if(this.lastSlideId != -1 ) {
						this.slidesArr[this.lastSlideId].caption.css("display", "none");					
					}
					self._showCaption(self.currentSlideId);
				} 
				this.isAnimating = false;
				this.settings.afterSlideChange.call(this);
			},			
			// Show caption with specified id
			_showCaption:function (id) {
				var caption = this.slidesArr[id].caption;

				if(caption && caption.length > 0) {
					caption.css("display", "block");
					
					var self = this;						
					
					var currItem,
						fadeEnabled,
						moveEnabled,				
						effectName,	
						effectsObject,
						moveEffectProperty,
						currEffects,
						newEffectObj,	
						moveOffset,
						delay,
						speed,
						easing,
						moveProp;
					
					var captionItems = caption.children();
					
					// clear previous animations
					if(this._captionAnimateTimeouts.length > 0) {
						for(var a = this._captionAnimateTimeouts.length - 1; a > -1; a--) {  
							clearTimeout(this._captionAnimateTimeouts.splice(a, 1));
						}
					}
					if(this._captionAnimateProperties.length > 0) {						
						var cItemTemp;
						for(var k = this._captionAnimateProperties.length - 1; k > -1; k--) {  
							cItemTemp = this._captionAnimateProperties[k];							
							if(cItemTemp) {								
								if(!this._useWebkitTransition) {
									if(cItemTemp.running) {
										cItemTemp.captionItem.stop(true, true);
									} else {
										cItemTemp.captionItem.css(cItemTemp.css);
									}
								}		
							}
							this._captionAnimateProperties.splice(k, 1);
						}
						
					}
					
					
					// parse each caption item on slide
					for(var i = 0; i < captionItems.length; i++) {
						currItem = $(captionItems[i]);		

						effectsObject = {};
						fadeEnabled = false;
						moveEnabled = false;
						moveEffectProperty = "";
						
						if(currItem.attr("data-show-effect") == undefined) {
							currEffects = this.settings.captionShowEffects;	
						} else {
							currEffects = currItem.attr("data-show-effect").split(" ");
						}

						// parse each effect in caption
						for(var q = 0; q < currEffects.length; q++) {			

							if(fadeEnabled && moveEnabled) {
								break;	
							}			

							effectName = currEffects[q].toLowerCase();

							if(!fadeEnabled && effectName == "fade") {
								fadeEnabled = true;
								effectsObject['opacity'] = 1;
							} else if(moveEnabled) {
								break;
							} else if(effectName == "movetop") {
								moveEffectProperty = "margin-top";
							} else  if(effectName == "moveleft") {
								moveEffectProperty = "margin-left";
							} else  if(effectName == "movebottom") {						
								moveEffectProperty = "margin-bottom";
							} else  if(effectName == "moveright") {
								moveEffectProperty = "margin-right";
							}

							if(moveEffectProperty != "") {
								effectsObject['moveProp'] = moveEffectProperty;	
								if(!self._useWebkitTransition) { 
									effectsObject['moveStartPos'] = parseInt(currItem.css(moveEffectProperty), 10);
								} else {
									effectsObject['moveStartPos'] = 0;
								}
								
								moveEnabled = true;
							}
						}

						moveOffset = parseInt(currItem.attr("data-move-offset"), 10);					
						if(isNaN(moveOffset)) {					
							moveOffset = this.settings.captionMoveOffset;
						}

						delay = parseInt(currItem.attr("data-delay"), 10);		
						if(isNaN(delay)) {
							delay = self.settings.captionShowDelay * i;
						}

						speed = parseInt(currItem.attr("data-speed"), 10);		
						if(isNaN(speed)) {
							speed = self.settings.captionShowSpeed;
						}

						easing = currItem.attr("data-easing");
						if(!easing) {
							easing = self.settings.captionShowEasing;
						}

						newEffectObj = {};

						if(moveEnabled) {	
							moveProp = effectsObject.moveProp;
							if(moveProp == "margin-right") {						
								moveProp = "margin-left";
								newEffectObj[moveProp] = effectsObject.moveStartPos + moveOffset;						
							} else if(moveProp == "margin-bottom") {
								moveProp = "margin-top";
								newEffectObj[moveProp] = effectsObject.moveStartPos + moveOffset;	
							} else {								
								newEffectObj[moveProp] = effectsObject.moveStartPos - moveOffset;				
							}
						}
						
						

						
						if(!self._removeFadeAnimation && fadeEnabled) {							
							currItem.css("opacity",0);							
						}
						
						if(!self._useWebkitTransition) {							
							currItem.css("visibility","hidden");
							currItem.css(newEffectObj);	
							if(moveEnabled) {	
								newEffectObj[moveProp] = effectsObject.moveStartPos; 
							}
							if(!self._removeFadeAnimation && fadeEnabled) {
								newEffectObj.opacity = 1;
							}
						} else {
							var cssObj = {};
							if(moveEnabled) {
								cssObj['-webkit-transition-duration'] = "0";
								cssObj['-webkit-transition-property'] = "none";
								
								cssObj["-webkit-transform"] = "translate3d(" + 
									(isNaN(newEffectObj["margin-left"]) ? 0 : (newEffectObj["margin-left"] + "px")) +
									", " +
									(isNaN(newEffectObj["margin-top"]) ? 0 : (newEffectObj["margin-top"] + "px")) +
									",0)"; 
								delete newEffectObj["margin-left"];
								delete newEffectObj["margin-top"];
								
								
								newEffectObj["-webkit-transform"] = "translate3d(0,0,0)";
							}
							
							
							
							newEffectObj.visibility = "visible";
							newEffectObj.opacity = 1;		
							if(!self._removeFadeAnimation && fadeEnabled) {
													
								cssObj["opacity"] = 0;
							}
							cssObj["visibility"] = "hidden";	
							currItem.css(cssObj);
						}
						
						
							

						this._captionAnimateProperties.push({captionItem:currItem, css:newEffectObj, running:false});
						// animate caption
						this._captionAnimateTimeouts.push(setTimeout((function (cItem, animateData, cSpeed, cEasing, cId, objFadeEnabled, objMoveEnabled) {	
							return function() {	
								self._captionAnimateProperties[cId].running = true;
								if(!self._useWebkitTransition) {									
									cItem.css("visibility","visible").animate(animateData, cSpeed, cEasing, function(){	
										if(self._isIE8 && objFadeEnabled) {
											cItem.get(0).style.removeAttribute('filter');
										}											
										delete self._captionAnimateProperties[cId];
									});
								} else {	
									
									cItem.css({'-webkit-transition-duration': (cSpeed + "ms"), 
										'-webkit-transition-property': 'opacity' + (objMoveEnabled ? ', -webkit-transform' : ''),
										'-webkit-transition-timing-function':'ease-out'});
									cItem.css(animateData);									
								}
							};
						})(currItem, newEffectObj, speed, easing, i, fadeEnabled, moveEnabled), delay));				
					}		
				}		
			},	/* _showCaption end */
			// scale image and center it if needed
			_scaleImage:function(img, containerWidth, containerHeight) {	
				
				var imgScaleMode = this.settings.imageScaleMode;
				var imgAlignCenter = this.settings.imageAlignCenter;
				
				if(imgAlignCenter || imgScaleMode == "fill" || imgScaleMode == "fit") {			
					
					var isReloaded = false;			
					function scaleImg () {						
						var hRatio, vRatio, ratio, nWidth, nHeight;
						var _tempImg = new Image();
						// fix android and BB bug, load again…
						_tempImg.onload = function() {
							var imgWidth = this.width;
							var imgHeight = this.height;
							
							
							var imgBorderSize = parseInt(img.css("borderWidth"), 10);            	
							imgBorderSize = isNaN(imgBorderSize) ? 0 : imgBorderSize;							
							
							if(imgScaleMode == "fill" || imgScaleMode == "fit") {						
								
		
								hRatio = containerWidth / imgWidth;
								vRatio = containerHeight / imgHeight;
		
								if (imgScaleMode  == "fill") {
									ratio = hRatio > vRatio ? hRatio : vRatio;                    			
								} else if (imgScaleMode  == "fit") {
									ratio = hRatio < vRatio ? hRatio : vRatio;             		   	
								} else {
									ratio = 1;
								}
		
								nWidth = parseInt(imgWidth * ratio, 10) - imgBorderSize;
								nHeight = parseInt(imgHeight * ratio, 10) - imgBorderSize;									
								
								img.attr({"width":nWidth, "height":nHeight}).css({"width": nWidth, "height": nHeight});
							} else {								
								nWidth = imgWidth - imgBorderSize;
								nHeight = imgHeight - imgBorderSize;
								
								img.attr("width",nWidth).attr("height",nHeight);								
							}
							// center image in needed
							if (imgAlignCenter) {            		
								img.css({"margin-left": Math.floor((containerWidth - nWidth) / 2), "margin-top":Math.floor((containerHeight - nHeight) / 2)});            		
							}  
						};
						_tempImg.src = img.attr("src");
					};
					
					img.removeAttr('height').removeAttr('width');
					if (!this._isImageLoaded(img.get(0))) { 
						$('<img />').load( function(){							
							scaleImg();
						}).attr('src', img.attr("src"));						
					} else {
						scaleImg();
					}
				}
			},   /* _scaleImage end */
			_isImageLoaded:function (img) {
				if(img) {
					if (!img.complete) {
				        return false;
				    }

				    if (typeof img.naturalWidth != "undefined" && img.naturalWidth == 0) {
				        return false;
				    }
				} else {
					return false;
				}
			    return true;				 
			} /* _isImageLoaded end */
	}; /* RoyalSlider.prototype end */

	$.fn.royalSlider = function(options) {    	
		return this.each(function(){
			var royalSlider = new RoyalSlider($(this), options);
			$(this).data("royalSlider", royalSlider);
		});
	};

	$.fn.royalSlider.defaults = {    
			lockAxis: true, 						// Drag navigation only on one axis
			
			preloadNearbyImages:true,               // Preloads two nearby images, if lazy loading is enabled.
			imageScaleMode:"none",                  // Scale mode of images. "fill", "fit" or "none"
			imageAlignCenter:false,					// Aligns all images to center.
			
			keyboardNavEnabled:false,				// Keyboard arrows navigation

			directionNavEnabled:true,               // Direction (arrow) navigation (true or false)
			directionNavAutoHide:false,             // Direction (arrow) navigation auto hide on hover. (On touch devices arrows are always shown)
			hideArrowOnLastSlide:true,             // Auto hide right arrow on last slide and left on first slide. Always true for touch devices.

			slideTransitionType: "move",			// "fade" or "move"
			slideTransitionSpeed:400,               // Slide transition speed in ms (1000ms = 1s)
			slideTransitionEasing:"easeInOutSine",  // Easing type for slide transition. Types: http://hosted.zeh.com.br/tweener/docs/en-us/misc/transitions.html

			captionAnimationEnabled:true,           // Set to false if you want to remove all animations from captions  
			captionShowEffects:["fade","moveleft"], // Default array of effects: 
													// ["fade" or "" + "moveleft", or "moveright", or "movetop", or "movebottom"]
			captionMoveOffset:20,                   // Default distance for move effect in px
			captionShowSpeed:400,                   // Default caption show speed in ms
			captionShowEasing:"easeOutCubic",       // Default caption show easing
			captionShowDelay:200,                   // Default delay between captions on one slide show

			controlNavEnabled:true,                 // Control navigation (bullets, thumbs)  enabled
			controlNavThumbs:false,	                // Use thumbs for control navigation (use data-thumb="myThumb.jpg" attribute in html royalSlide item)
			controlNavThumbsNavigation:true,        // Enables navigation for thumbs
			controlNavThumbsSpeed:400,				// Thumbnails navigation move speed (1000ms = 1s)
			controlNavThumbsEasing:"easeInOutSine", // Thumbnails navigation easing type

			slideshowEnabled:false,                 // Autoslideshow enabled          
			slideshowDelay:5000,                    // Delay between slides in slideshow
			slideshowPauseOnHover:true,             // Pause slideshow on hover
			slideshowAutoStart:true,                // Auto start slideshow 

			welcomeScreenEnabled:false,              // Welcome (loading) screen enabled
			welcomeScreenShowSpeed:500,             // Welcome screen fade out speed

			minSlideOffset:20,                      // Minimum distance in pixels to show next slide while dragging
			
			disableTranslate3d:false,   			// Disables CSS3 transforms on touch devices

			removeCaptionsOpacityInIE8:false,       // If animated caption with fade effect has no background color, so turn this option on. 
													// Fix for pixelated text bug in IE8 and lower. Removes fade effect animation.

			startSlideIndex: 0,						// Start slide index (starting from 0).
			slideSpacing: 0,						// Distance between slides in pixels.
			
			blockLinksOnDrag:true,			        // Blocks all <a> links when dragging.
			nonDraggableClassEnabled:true,          // Prevents dragging on all elements that have 'non-draggable' class inside slide.
			
			dragUsingMouse:true,					// Drag using mouse on non-touch devices
			
			autoScaleSlider: false,                 // Overrides css slider size settings. Sets slider height based on base width and height. Don't forget to set slider width to 100%.
	   		autoScaleSliderWidth: 960,              // Base slider width
	   		autoScaleSliderHeight: 400,             // Base slider height
			
			
			beforeSlideChange: function(){},        // Callback, triggers before slide transition
			afterSlideChange: function(){},         // Callback, triggers after slide transition

			beforeLoadStart:function() {},			// Callback, triggers before first image loading starts
			loadingComplete: function() {},         // Callback, triggers after loading complete, but before welcome screen animation
			allComplete: function() {}				// Callback, triggers after loading and welcome screen animation
	}; /* default options end */

	$.fn.royalSlider.settings = {};

})(jQuery);
