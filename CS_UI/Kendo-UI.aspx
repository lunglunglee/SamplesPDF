<%@ Page Language="C#" CodeFile="Kendo-UI.aspx.cs" Inherits="Kendo_UI" %>

<%@ Register Assembly="RadPdf" Namespace="RadPdf.Web.UI" TagPrefix="radPdf" %>

<!DOCTYPE html>
<html>
<head id="SampleHead" runat="server">
	<title>RAD PDF Sample</title>
	<link rel="stylesheet" href="kendo-ui/styles/kendo.common.core.min.css" />
	<link rel="stylesheet" href="kendo-ui/styles/kendo.default.min.css" />
	<script type="text/javascript" src="kendo-ui/js/jquery.min.js"></script>
	<script type="text/javascript" src="kendo-ui/js/kendo.ui.core.min.js"></script>
	<script type="text/javascript">
		var api = null;

		// Run the value of the menu item on select
		// Adapted from http://www.telerik.com/forums/accessing-the-original-menu-item-object-during-select-event
		function kendoOnSelectRunValue(e)
		{
			var item = $(e.item),
				menuElement = item.closest(".k-menu"),
				dataItem = this.options.dataSource,
				index = item.parentsUntil(menuElement, ".k-item").map(function () {
					return $(this).index();
				}).get().reverse();

			index.push(item.index());

			for (var i = -1, len = index.length; ++i < len;)
			{
				dataItem = dataItem[index[i]];
				dataItem = i < len-1 ? dataItem.items : dataItem;
			}

			if (dataItem.value)
			{
				dataItem.value();
			}
		}

		function radpdfOnResize()
		{
			var ele = $("#radpdf");

			ele.outerHeight($(window).innerHeight() - ele.offset().top);
		}

		function initRadPdf()
		{
			// Get id
			var id = "<%= PdfWebControl1.ClientID%>";

			// Get api instance
			api = new PdfWebControlApi(id);

			// Add event handler for object added
			api.addEventListener("objectAdded", function(evt) 
				{
					if (evt.obj.getType() == api.ObjectType.ButtonField)
					{
						switch (addedButtonType)
						{
							case "reset":
								evt.obj.setProperties(
									{
										isReset: true,
										label: "Reset"
									});
								break;

							case "submit":
								evt.obj.setProperties(
									{
										isSubmit: true,
										label: "Submit"
									});
								break;
						}
					}
				});

			// Add menu
			$("#kendo-menu").kendoMenu({
				dataSource: [
					{
						text: "Insert",
						items: [
							{
								text: "Text",
								value: function(){api.setMode(api.Mode.InsertTextShape);}
							},
							{
								text: "Whiteout",
								value: function(){api.setMode(api.Mode.InsertWhiteoutShape);}
							},
							{
								text: "Image",
								value: function(){api.setMode(api.Mode.InsertImageShape);}
							},
							{
								text: "Freehand",
								value: function(){api.setMode(api.Mode.InsertInkShape);}
							},
							{
								text: "Link",
								value: function(){api.setMode(api.Mode.InsertLinkAnnotation);}
							},
							{
								text: "Form Field",
								items: [
									{
										text: "Text",
										value: function(){api.setMode(api.Mode.InsertTextField);}
									},
									{
										text: "Checkbox",
										value: function(){api.setMode(api.Mode.InsertCheckField);}
									},
									{
										text: "Radio",
										value: function(){api.setMode(api.Mode.InsertRadioField);}
									},
									{
										text: "Dropdown",
										value: function(){api.setMode(api.Mode.InsertComboField);}
									},
									{
										text: "Listbox",
										value: function(){api.setMode(api.Mode.InsertListField);}
									},
									{
										text: "Reset Button",
										value: function(){api.setMode(api.Mode.InsertButtonField);addedButtonType="reset";}
									},
									{
										text: "Submit Button",
										value: function(){api.setMode(api.Mode.InsertButtonField);addedButtonType="submit";}
									}
								]
							},
							{
								text: "Line",
								value: function(){api.setMode(api.Mode.InsertLineShape);}
							},
							{
								text: "Arrow",
								value: function(){api.setMode(api.Mode.InsertArrowShape);}
							},
							{
								text: "Rectangle",
								value: function(){api.setMode(api.Mode.InsertRectangleShape);}
							},
							{
								text: "Circle",
								value: function(){api.setMode(api.Mode.InsertEllipseShape);}
							},
							{
								text: "Checkmark",
								value: function(){api.setMode(api.Mode.InsertCheckShape);}
							}
						]
					},
					{
						text: "Annotate",
						items: [
							{
								text: "Sticky Note",
								value: function(){api.setMode(api.Mode.InsertTextAnnotation);}
							},
							{
								text: "Highlight",
								value: function(){api.setMode(api.Mode.InsertHighlightAnnotation);}
							},
							{
								text: "Insert",
								value: function(){api.setMode(api.Mode.InsertCaretAnnotation);}
							},
							{
								text: "Oval",
								value: function(){api.setMode(api.Mode.InsertCircleAnnotation);}
							},
							{
								text: "Rectangle",
								value: function(){api.setMode(api.Mode.InsertSquareAnnotation);}
							},
							{
								text: "Strikeout",
								value: function(){api.setMode(api.Mode.InsertStrikeoutAnnotation);}
							},
							{
								text: "Underline",
								value: function(){api.setMode(api.Mode.InsertUnderlineAnnotation);}
							}
						]
					},
					{
						text: "Pages",
						items: [
							{
								text: "Append PDF",
								value: api.append
							},
							{
								text: "Move Page",
								value: api.getPageViewed().movePage //show dialog
							},
							{
								text: "Delete Page",
								value: function(){api.getPageViewed().deletePage(true);} //show confirmation dialog
							},
							{
								text: "Rotate Left",
								value: function(){api.getPageViewed().rotatePage(-90);}
							},
							{
								text: "Rotate Right",
								value: function(){api.getPageViewed().rotatePage(90);}
							},
							{
								text: "Crop",
								value: function(){api.setMode(api.Mode.CropPage);}
							},
							{
								text: "Deskew",
								value: function(){api.setMode(api.Mode.DeskewPage);}
							}
						]
					}
				],
				openOnClick: true,
				select: kendoOnSelectRunValue,
			});

			// Add toolbar
			$("#kendo-toolbar").kendoToolBar({
				resizable: true,
				items: [
					{
						type: "buttonGroup",
						buttons: [
							{ text: "Save", click: api.save },
							{ text: "Download", click: api.download },
							{ text: "Print", click: api.print }
						]
					},
					{ type: "separator" },
					{
						type: "buttonGroup",
						buttons: [
							{
								text: "Previous Page", 
								click: function()
									{
										api.setView(
											{
												page: Math.max(api.getView().page - 1, 1),
												scrollY: 0
											});
									}
							},
							{
								text: "Next Page", 
								click: function()
									{
										api.setView(
											{
												page: Math.min(api.getView().page + 1, api.getPageCount()),
												scrollY: 0
											});
									}
							}
						]
					},
					{ type: "separator" },
					{
						type: "buttonGroup",
						buttons: [
							{
								text: "-", 
								click: function()
									{
										api.setView(
											{
												zoom: Math.max(Math.floor(api.getView().zoom * 0.8), 25)
											});
									}
							},
							{
								text: "Fit", 
								click: function()
									{
										api.setView(
											{
												zoom: api.ViewZoom.ZoomFitAll
											});
									}
							},
							{
								text: "100%", 
								click: function()
									{
										api.setView(
											{
												zoom: api.ViewZoom.Zoom100
											});
									}
							},
							{
								text: "+", 
								click: function()
									{
										api.setView(
											{
												zoom: Math.min(Math.floor(api.getView().zoom * 1.25), 500)
											});
									}
							}
						]
					}
				]
			});

			// Show RAD PDF
			$("#radpdf").show();

			// Resize RAD PDF with window resizing
			radpdfOnResize();
			$(window).resize(radpdfOnResize);
		}
	</script>
	<style type="text/css">
	body, html
	{
	margin:0px;
	padding:0px;
	}
	</style>
</head>
<body>
	<form id="SampleForm" runat="server">
	<div id="kendo">
		<div id="kendo-menu"></div>
		<div id="kendo-toolbar"></div>
	</div>
	
	<div id="radpdf" style="display:none;overflow:hidden;">
		<radPdf:PdfWebControl ID="PdfWebControl1" RunAt="server"
			Height="100%" 
			Width="100%" 
			OnClientLoad="initRadPdf();" 
			HideBookmarks="True"
			HideBottomBar="True"
			HideDownloadButton="True"
			HideObjectPropertiesBar="True"
			HideSearchText="True"
			HideSideBar="True"
			HideThumbnails="True"
			HideToolsTabs="True"
			HideTopBar="True"
			ViewerPageLayoutDefault="SinglePageContinuous"
			/>
	</div>
	</form>
</body>
</html>

