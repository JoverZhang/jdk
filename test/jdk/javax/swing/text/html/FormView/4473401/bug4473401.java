/*
 * Copyright (c) 2003, 2025, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
 */

/* @test
 * @bug 4473401
 * @summary Tests if FormSubmitEvent is submitted correctly.
 * @library /java/awt/regtesthelpers
 * @build PassFailJFrame
 * @run main/manual bug4473401
*/

import java.io.File;
import javax.swing.JEditorPane;
import javax.swing.JFrame;
import javax.swing.event.HyperlinkEvent;
import javax.swing.event.HyperlinkListener;
import javax.swing.text.html.FormSubmitEvent;
import javax.swing.text.html.HTMLEditorKit;

public class bug4473401 implements HyperlinkListener {

    static final String INSTRUCTIONS = """
        The test window displays an HTML frameset with a frame
        on the left and another to the right.
        Push the 'Submit Query' button in the left frame to perform testing.
        The window should be updated to have only one frame with the
        message 'If you see this page the test PASSED'.
        If it appears, PASS the test, otherwise FAIL the test.
    """;

    static JEditorPane jep;
    static JFrame createUI() {

        JFrame frame = new JFrame("bug4473401");
        jep = new JEditorPane();
        jep.addHyperlinkListener(new bug4473401());
        HTMLEditorKit kit = new HTMLEditorKit();
        kit.setAutoFormSubmission(false);
        jep.setEditorKit(kit);
        jep.setEditable(false);

        try {
            File file = new File(System.getProperty("test.src", "."), "frameset.html");
            System.out.println(file.toURI().toURL());
            jep.setPage(file.toURL());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        frame.add(jep);
        frame.setSize(500, 500);
        return frame;
    }

    public void hyperlinkUpdate(HyperlinkEvent e) {
        if (e instanceof FormSubmitEvent) {
            jep.setText("If you see this page the test<font color=green> PASSED</font></CENTER>");
        }
    }

    public static void main(String args[]) throws Exception {
        PassFailJFrame.builder()
            .title("Test Instructions")
            .instructions(INSTRUCTIONS)
            .columns(40)
            .testUI(bug4473401::createUI)
            .build()
            .awaitAndCheck();
    }
}
