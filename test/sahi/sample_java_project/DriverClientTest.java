package net.sf.sahi.client;

/**
 * Sahi - Web Automation and Test Tool
 * 
 * Copyright  2006  V Narayan Raman
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * This is a sample junit test used to demonstrate various 
 * apis of Sahi.
 * You need sahi/lib/sahi.jar in your classpath
 * 
 */
public class DriverClientTest extends SahiTestCase {
//	protected String baseURL = "http://narayan:10000";
	protected String baseURL = "http://sahi.co.in";
	private static final long serialVersionUID = 5492057299341976253L;
	
	public void testZK(){
		browser.setSpeed(210);
		browser.navigateTo("http://www.zkoss.org/zkdemo/userguide/");
		browser.div("Hello World").click();
		browser.span("Pure Java").click();
		browser.div("Various Form").click();
//		BrowserCondition condition = new BrowserCondition(browser){@Override
//			public boolean test() {
//				return browser.textbox("z-intbox[1]").isVisible();
//			}};
//		browser.waitFor(condition, 5000);
		assertTrue(browser.textbox("z-intbox[1]").isVisible());
		browser.div("Comboboxes").click();
		browser.textbox("z-combobox-inp").setValue("aa");
		browser.italic("z-combobox-btn").click();
		browser.cell("Simple and Rich").click();
		browser.italic("z-combobox-btn[1]").click();
		browser.span("The coolest technology").click();
		browser.italic("z-combobox-btn[2]").click();
		browser.image("CogwheelEye-32x32.gif").click();
		assertTrue(browser.textbox("z-combobox-inp[2]").exists());		
	}
	
	public void testOpen(){
		browser.navigateTo(baseURL + "/demo/formTest.htm");
		browser.textbox("t1").setValue("aaa");			
		browser.link("Back").click();
		browser.link("Table Test").click();		
		assertEquals("Cell with id", browser.cell("CellWithId").getText());
	}

	public void testFetch() throws Exception {
		browser.navigateTo(baseURL + "/demo/formTest.htm");
		assertEquals(baseURL + "/demo/formTest.htm", browser.fetch("window.location.href"));
		
	}
	
	public void testDragDrop(){
		browser.navigateTo("http://www.snook.ca/technical/mootoolsdragdrop/");
		browser.div("Drag me").dragAndDropOn(browser.div("Item 2"));
//		browser.waitFor(3000);
		browser.div("dropped").exists();
//		browser.waitFor(3000);		
		browser.div("Item 1").exists();
		browser.div("Item 3").exists();
		browser.div("Item 4").exists();
	}
	
	public void testSahiDemoAccessors(){
		browser.navigateTo(baseURL + "/demo/formTest.htm");
		assertEquals("", browser.textbox("t1").value());
		assertNotNull(browser.textbox(1));
		assertNotNull(browser.textbox("$a_dollar"));
		browser.textbox("$a_dollar").setValue("adas");
		assertEquals("", browser.textbox(1).value());
		assertNotNull(browser.textarea("ta1"));
		assertEquals("", browser.textarea("ta1").value());
		assertNotNull(browser.textarea(1));
		assertEquals("", browser.textarea(1).value());
		assertNotNull(browser.checkbox("c1"));
		assertEquals("cv1", browser.checkbox("c1").value());
		assertNotNull(browser.checkbox(1));
		assertEquals("cv2", browser.checkbox(1).value());
		assertNotNull(browser.checkbox("c1[1]"));
		assertEquals("cv3", browser.checkbox("c1[1]").value());
		assertNotNull(browser.checkbox(3));
		assertEquals("", browser.checkbox(3).value());
		assertNotNull(browser.radio("r1"));
		assertEquals("rv1", browser.radio("r1").value());
		assertNotNull(browser.password("p1"));
		assertEquals("", browser.password("p1").value());
		assertNotNull(browser.password(1));
		assertEquals("", browser.password(1).value());
		assertNotNull(browser.select("s1"));
		assertEquals("o1", browser.select("s1").selectedText());
		assertNotNull(browser.select("s1Id[1]"));
		assertEquals("o1", browser.select("s1Id[1]").selectedText());
		assertNotNull(browser.select(2));
		assertEquals("o1", browser.select(2).selectedText());
		assertNotNull(browser.button("button value"));
		assertNotNull(browser.button("btnName[1]"));
		assertNotNull(browser.button("btnId[2]"));
		assertNotNull(browser.button(3));
		assertNotNull(browser.submit("Add"));
		assertNotNull(browser.submit("submitBtnName[1]"));
		assertNotNull(browser.submit("submitBtnId[2]").fetch());
		assertNotNull(browser.submit(3).fetch());
		assertNotNull(browser.image("imageAlt1").fetch());
		assertNotNull(browser.image("imageId1[1]").fetch());
		assertNotNull(browser.image(2).fetch());
		assertNull(browser.link("Back22").fetch());
		assertNotNull(browser.link("Back").fetch());
		assertNotNull(browser.accessor("document.getElementById('ta1')"));
		assertNotNull(browser.byId("ta1"));
		assertNotNull(browser.byClassName("button[1]", "INPUT"));
		browser.navigateTo("tableTest.htm");
		assertNotNull(browser.byXPath("//table[1]/tbody/tr[1]/td[@id='CellWithId']"));
	}
	
	public void testSelect(){
		browser.navigateTo(baseURL + "/demo/formTest.htm");
		assertEquals("o1", browser.select("s1Id[1]").selectedText());
		browser.select("s1Id[1]").choose("o2");
		assertEquals("o2", browser.select("s1Id[1]").selectedText());
	}
	
	public void testSetFile(){
		browser.navigateTo(baseURL + "/demo/php/fileUpload.htm");
		browser.file("file").setFile("scripts/demo/uploadme.txt");
		browser.submit("Submit Single").click();
		assertTrue(browser.span("size").exists());
		assertTrue(browser.span("size").text().indexOf("0.3046875 Kb") != -1);
		assertTrue(browser.span("type").text().indexOf("Single") != -1);
		browser.link("Back to form").click();
	}
	
	public void testMultiFileUpload(){
		browser.navigateTo(baseURL + "/demo/php/fileUpload.htm");
		browser.file("file[]").setFile("scripts/demo/uploadme.txt");
		browser.file("file[]").setFile("scripts/demo/uploadme2.txt");
		browser.submit("Submit Array").click();
		assertTrue(browser.span("type").text().indexOf("Array") != -1);
		assertTrue(browser.span("file").text().indexOf("uploadme.txt") != -1);
		assertTrue(browser.span("size").text().indexOf("0.3046875 Kb") != -1);
		
		assertTrue(browser.span("file[1]").text().indexOf("uploadme2.txt") != -1);
		assertTrue(browser.span("size[1]").text().indexOf("0.32421875 Kb") != -1);
	}
	
	public void testSahiDemoClicks(){
		browser.navigateTo(baseURL + "/demo/formTest.htm");
		assertNotNull(browser.checkbox("c1"));
	    browser.checkbox("c1").click();
	    assertEquals("true", browser.checkbox("c1").fetch("checked"));
	    browser.checkbox("c1").click();
	    assertEquals("false", browser.checkbox("c1").fetch("checked"));
	    
	    assertNotNull(browser.radio("r1"));
	    browser.radio("r1").click();
	    assertEquals("true", browser.radio("r1").fetch("checked"));
	    assertTrue(browser.radio("r1").checked());
	    assertFalse(browser.radio("r1[1]").checked());
	    browser.radio("r1[1]").click();
	    assertEquals("false", browser.radio("r1").fetch("checked"));
	    assertTrue(browser.radio("r1[1]").checked());
	    assertFalse(browser.radio("r1").checked());
	}
	
	public void testLinks(){
		browser.navigateTo(baseURL + "/demo/index.htm");
		browser.link("Link Test").click();
		browser.link("linkByContent").click();
		browser.link("Back").click();
		browser.link("link with return true").click();
		assertTrue(browser.textarea("ta1").exists());
		assertEquals("", browser.textarea("ta1").value());
		browser.link("Back").click();
		browser.link("Link Test").click();
		browser.link("link with return false").click();
		assertTrue(browser.textbox("t1").exists());
		assertEquals("formTest link with return false", browser.textbox("t1").value());
		assertTrue(browser.link("linkByContent").exists());

		browser.link("link with returnValue=false").click();
		assertTrue(browser.textbox("t1").exists());
		assertEquals("formTest link with returnValue=false", browser.textbox("t1").value());
		browser.link("added handler using js").click();
		assertTrue(browser.textbox("t1").exists());
		assertEquals("myFn called", browser.textbox("t1").value());
		browser.textbox("t1").setValue("");
		browser.image("imgWithLink").click();
		browser.link("Link Test").click();
		browser.image("imgWithLinkNoClick").click();
		assertTrue(browser.textbox("t1").exists());
		assertEquals("myFn called", browser.textbox("t1").value());
		browser.link("Back").click();		
	}
	
	public void testPopupTitleNameMix() {
		browser.navigateTo(baseURL + "/demo/index.htm");
		browser.link("Window Open Test").click();
		browser.link("Window Open Test With Title").click();
		browser.link("Table Test").click();
		
		Browser popupPopWin = browser.popup("popWin");
		
		popupPopWin.link("Link Test").click();
		browser.link("Back").click();
		
		Browser popupWithTitle = browser.popup("With Title");
		
		popupWithTitle.link("Form Test").click();
		browser.link("Table Test").click();
		popupWithTitle.textbox("t1").setValue("d");
		browser.link("Back").click();
		popupWithTitle.textbox(1).setValue("e");
		browser.link("Table Test").click();
		popupWithTitle.textbox("name").setValue("f");
		assertNotNull(popupPopWin.link("linkByHtml").exists());

		assertNotNull(browser.cell("CellWithId"));
		assertEquals("Cell with id", browser.cell("CellWithId").text());
		popupWithTitle.link("Break Frames").click();
		
		Browser popupSahiTests = browser.popup("Sahi Tests");
		popupSahiTests.close();
		
		popupPopWin.link("Break Frames").click();
//		popupPopWin.link("Close Self").click();
		popupPopWin.close();
		browser.link("Back").click();
	}
	
	public void testIn() {
		browser.navigateTo(baseURL + "/demo/tableTest.htm");
		assertEquals("111", browser.textarea("ta").near(browser.cell("a1")).getValue());
		assertEquals("222", browser.textarea("ta").near(browser.cell("a2")).getValue());
		browser.link("Go back").in(browser.cell("a1").parentNode()).click();
		assertTrue(browser.link("Link Test").exists());
	}
	
	public void testExists(){
		browser.navigateTo(baseURL + "/demo/index.htm");
		assertTrue(browser.link("Link Test").exists());
		assertFalse(browser.link("Link Test NonExistent").exists());		
	}
	
	public void testWaitFor() {
		browser.navigateTo(baseURL + "/demo/waitCondition1.htm");
		BrowserCondition condition = new BrowserCondition(browser){@Override
		public boolean test() {
			return "populated".equals(browser.textbox("t1").value());
		}};
		browser.waitFor(condition, 5000);
		assertEquals("populated", browser.textbox("t1").value());
	}
	
	public void alert1(String message) {
		browser.navigateTo(baseURL + "/demo/alertTest.htm");
		browser.textbox("t1").setValue("Message " + message);
		browser.button("Click For Alert").click();
		browser.navigateTo("/demo/alertTest.htm");
		browser.waitFor(1000);
		assertEquals("Message " + message, browser.lastAlert());
		browser.clearLastAlert();
		assertNull(browser.lastAlert());
	}
	
	public void testAlert(){
		alert1("One");
		alert1("Two");
		alert1("Three");
		browser.button("Click For Multiline Alert").click();
		assertEquals("You must correct the following Errors:\nYou must select a messaging price plan.\nYou must select an international messaging price plan.\nYou must enter a value for the Network Lookup Charge", browser.lastAlert());
	}	
	
	public void testGoogle(){
		browser.open();
		browser.navigateTo("http://www.google.com");
		browser.setValue(browser.textbox("q"), "sahi forums");
		browser.submit("Google Search").click();
		browser.waitFor(1000);
		browser.link("Sahi - Web Automation and Test Tool").click();		
		browser.link("Login").click();
		assertTrue(browser.textbox("req_username").exists());
	}
	
	public void testForumsExists() throws Exception {
		browser.navigateTo("http://sahi.co.in/forums/");		
		browser.link("Login").click();
		assertTrue(browser.textbox("req_username").exists());		
	}
	
	public void testConfirm(){
		browser.navigateTo(baseURL + "/demo/confirmTest.htm");
		browser.expectConfirm("Some question?", true);
		browser.button("Click For Confirm").click();
		assertEquals("oked", browser.textbox("t1").value());
		browser.navigateTo("/demo/confirmTest.htm");
		browser.waitFor(1000);
		assertEquals("Some question?", browser.lastConfirm());
		browser.clearLastConfirm();
		assertNull(browser.lastConfirm());

		browser.expectConfirm("Some question?", false);
		browser.button("Click For Confirm").click();
		assertEquals("canceled", browser.textbox("t1").value());
		assertEquals("Some question?", browser.lastConfirm());
		browser.clearLastConfirm();
		assertNull(browser.lastConfirm());

		browser.expectConfirm("Some question?", true);
		browser.button("Click For Confirm").click();
		assertEquals("oked", browser.textbox("t1").value());
		assertEquals("Some question?", browser.lastConfirm());				
		browser.clearLastConfirm();
		assertNull(browser.lastConfirm());
	}
	
	public void testPrompt(){
		browser.navigateTo(baseURL + "/demo/promptTest.htm");
		browser.expectPrompt("Some prompt?", "abc");
		browser.button("Click For Prompt").click();
		assertNotNull(browser.textbox("t1"));
		assertEquals("abc", browser.textbox("t1").value());
		browser.navigateTo("/demo/promptTest.htm");
		browser.waitFor(2000);
		assertEquals("Some prompt?", browser.lastPrompt());
		browser.clearLastPrompt();
		assertNull(browser.lastPrompt());		
	}

	public void testIsVisible(){
		browser.navigateTo(baseURL + "/demo/index.htm");
		browser.link("Visible Test").click();
		assertTrue(browser.spandiv("using display").isVisible());

		browser.button("Display none").click();
		assertFalse(browser.isVisible(browser.spandiv("using display")));
		browser.button("Display block").click();
		assertTrue(browser.isVisible(browser.spandiv("using display")));

		browser.button("Display none").click();
		assertFalse(browser.isVisible(browser.spandiv("using display")));
		browser.button("Display inline").click();
		assertTrue(browser.isVisible(browser.spandiv("using display")));

		assertTrue(browser.isVisible(browser.spandiv("using visibility")));
		browser.button("Visibility hidden").click();
		assertFalse(browser.isVisible(browser.spandiv("using visibility")));
		browser.button("Visibility visible").click();
		assertTrue(browser.isVisible(browser.spandiv("using visibility")));

		assertFalse(browser.isVisible(browser.byId("nestedBlockInNone")));
		assertFalse(browser.isVisible(browser.byId("absoluteNestedBlockInNone")));

		
	}
	
	public void testCheck() throws Exception {
		browser.navigateTo(baseURL + "/demo/");
		browser.link("Form Test").click();
		assertEquals("false", browser.checkbox("c1").fetch("checked"));
		assertFalse(browser.checkbox("c1").checked());
		browser.checkbox("c1").check();
		assertEquals("true", browser.checkbox("c1").fetch("checked"));
		assertTrue(browser.checkbox("c1").checked());
		browser.checkbox("c1").check();
		assertEquals("true", browser.checkbox("c1").fetch("checked"));
		browser.checkbox("c1").uncheck();
		assertEquals("false", browser.checkbox("c1").fetch("checked"));
		browser.checkbox("c1").uncheck();
		assertEquals("false", browser.checkbox("c1").fetch("checked"));
		browser.checkbox("c1").click();
		assertEquals("true", browser.checkbox("c1").fetch("checked"));
	}
	
	public void testFocus() throws Exception {
		browser.navigateTo(baseURL + "/demo/focusTest.htm");
		browser.textbox("t2").focus();
		assertEquals("focused", browser.textbox("t1").value());
		browser.textbox("t2").removeFocus();
		assertEquals("not focused", browser.textbox("t1").value());
		browser.textbox("t2").focus();
		assertEquals("focused", browser.textbox("t1").value());		
	}
	
	public void testTitle() throws Exception {
		browser.navigateTo(baseURL + "/demo/index.htm");
		assertEquals("Sahi Tests", browser.title());
		browser.link("Form Test").click();
		assertEquals("Form Test", browser.title());
		browser.link("Back").click();
		browser.link("Window Open Test With Title").click();
		assertEquals("With Title", browser.popup("With Title").title());
	}
	
	public void testArea() throws Exception {
		browser.navigateTo(baseURL + "/demo/map.htm");
		browser.navigateTo("map.htm");
		assertTrue(browser.area("Record").exists());
		assertTrue(browser.area("Playback").exists());
		assertTrue(browser.area("Info").exists());
		assertTrue(browser.area("Circular").exists());
		browser.area("Record").mouseOver();
		assertEquals("Record", browser.div("output").getText());
		browser.mouseOver(browser.button("Clear"));
		assertEquals("", browser.div("output").getText());
		browser.click(browser.area("Record"));
		assertTrue(browser.link("linkByContent").exists());
		//browser.navigateTo("map.htm");		
	}
	
	public void testRegExp() throws Exception {
		browser.navigateTo(baseURL + "/demo/regexp.htm");
		assertEquals("Inner", browser.div("Inner").getText());
		assertEquals("Inner", browser.div("/Inner/[1]").getText());
		assertTrue(!browser.div("/Inner/[3]").exists());
		
		assertTrue(browser.link("/Vi/[0]").fetch("href").indexOf("0.htm")!=-1);
		assertTrue(browser.link("View[1]").fetch("href").indexOf("1.htm")!=-1);
		assertTrue(browser.link("/Vi/[2]").fetch("href").indexOf("2.htm")!=-1);
		assertTrue(browser.link("View[3]").fetch("href").indexOf("3.htm")!=-1);		
	}
	
	public void testContainsText() throws Exception {
		browser.navigateTo("http://sahi.co.in/demo/containTest.htm");
		assertTrue(browser.div("a").containsText("find me here"));
		assertTrue(browser.div("a").containsText("me"));
		assertTrue(browser.div("a").containsText("/find/"));
		assertTrue(browser.div("a").containsText("/f.*nd/"));
		assertTrue(browser.accessor("document.body").containsHTML("<DIV"));
		assertTrue(browser.accessor("document.body").containsHTML("/find .* here/"));		
	}
	
	public void testStyle() throws Exception {
		browser.navigateTo("http://sahi.co.in/demo/mouseover.htm");
		assertEquals(browser.span("Hi Kamlesh").style("font-size"), "12pt");
		assertEquals(browser.span("Hi Kamlesh").style("color"), "#0066cc");
	}
	
	public void testDoubleClick() throws Exception {
	    browser.navigateTo("http://sahi.co.in/demo/clicks.htm");
	    browser.div("dbl click me").doubleClick();
	    assertEquals("[DOUBLE_CLICK]", browser.textarea("t2").value());
	    browser.button("Clear").click();
	}
	
	
	public void testRightClick() throws Exception {
	    browser.navigateTo("http://sahi.co.in/demo/clicks.htm");
	    browser.div("right click me").rightClick();
	    assertEquals("[RIGHT_CLICK]", browser.textarea("t2").value());
	    browser.button("Clear").click();
	}
	
	public void testUnder() throws Exception {
		browser.navigateTo(baseURL + "/demo/tableTest.htm");
		assertEquals("x1-2", browser.cell(0).near(browser.cell("x1-0")).under(browser.tableHeader("header 3")).getText());
		assertEquals("x1-3", browser.cell(0).near(browser.cell("x1-0")).under(browser.tableHeader("header 4")).getText());
	}
	
	@Override
	public void setBrowser() {
//		firefox();
		ie8();
	}		
}
