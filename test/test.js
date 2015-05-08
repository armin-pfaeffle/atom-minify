ApImageZoom.prototype = {

	_init: function() {
		var self = this;

		this.loading = true;
		this.dragging = false;
		this.pinching = false;
		this.preventClickBecauseOfDragging = false;
		this.preventClickForDoubleClick = false;

		this._addWrapper();
		this._updateCssClasses();

		if (!this.imageUrl) {
			this.loading = false;
			this._showError('Invalid image url!');
			this.disable();
		}
		else {
			// Create a temporary hidden copy of image, so we obtain the real/natural size
			// We have to define the variable first, because of IE8 and lower
			this.$image = $('<img />');
			this.$image
				.hide()
				.prependTo(this.$wrapper)
				.load(function() {
					self._obtainNaturalImageSize();
					self._setup();
					self.$wrapper.removeClass(cssPrefix + 'loading');
				})
				.error(function() {
					self.loading = false;
					self.$wrapper.removeClass(cssPrefix + 'loading');
					self._showError('Error loading image!');
					self.disable();
				})
				.attr('src', this.imageUrl);
		}
	},

	_addWrapper: function() {
		// Setup wrapper and overlay which is for detecting all events
		this.$wrapper = $('<div></div>')
							.addClass(cssPrefix + 'wrapper')
							.addClass(cssPrefix + 'mode-' + this.mode)
							.addClass(cssPrefix + 'loading');
		this.$overlay = $('<div></div>')
							.addClass(cssPrefix + 'overlay')
							.appendTo(this.$wrapper);

		this._addLoadingAnimation();

		// Hide image and move it into added wrapper or add wrapper target container
		if (this.mode == 'image') {
			this.imageIsVisible = this.$target.is(':visible');
			this.$target
				.hide()
				.after(this.$wrapper)
				.appendTo(this.$wrapper);
		}
		else {
			this.$wrapper.appendTo(this.$target);
		}
	}
}
