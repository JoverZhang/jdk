#!/bin/bash
# Copyright (c) 2020, 2025, Oracle and/or its affiliates. All rights reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
#
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.
#
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
#
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
# or visit www.oracle.com if you need additional information or have any
# questions.
#

testnames=

testnames="$testnames MethodHandlesAsCollectorTest"
testnames="$testnames MethodHandlesCastFailureTest"
testnames="$testnames MethodHandlesGeneralTest"
testnames="$testnames MethodHandlesInvokersTest"
testnames="$testnames MethodHandlesPermuteArgumentsTest"
testnames="$testnames MethodHandlesSpreadArgumentsTest"

name_suffix='.java'

for i in ${testnames}
do
    fname="$i$name_suffix"
    cat << EOF > $fname
/*
 * Copyright (c) 2020, 2025, Oracle and/or its affiliates. All rights reserved.
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
 *
 */
// this file is auto-generated by $0. Do not edit manually.

EOF

for w in AOT DYNAMIC STATIC; do
    id=$(echo "$w" | awk '{print tolower($0)}')

    cat << EOF >> $fname
/*
 * @test id=$id
 * @summary Run the $fname test in CDSAppTester::$w workflow.
 * @requires vm.cds & vm.compMode != "Xcomp"
EOF

    if test "$w" == "AOT"; then
        cat << EOF >> $fname
 * @requires vm.cds.supports.aot.class.linking
 * @comment work around JDK-8345635
 * @requires !vm.jvmci.enabled
EOF
    fi

    cat << EOF >> $fname
 * @comment Some of the tests run excessively slowly with -Xcomp. The original
 *          tests aren't executed with -Xcomp in the CI pipeline, so let's exclude
 *          the generated tests from -Xcomp execution as well.
 * @library /test/lib /test/hotspot/jtreg/runtime/cds/appcds
 * @compile ../../../../../../jdk/java/lang/invoke/MethodHandlesTest.java
 *        ../../../../../../lib/jdk/test/lib/Utils.java
 *        ../../../../../../jdk/java/lang/invoke/$fname
 *        ../../../../../../jdk/java/lang/invoke/remote/RemoteExample.java
 *        ../../../../../../jdk/java/lang/invoke/common/test/java/lang/invoke/lib/CodeCacheOverflowProcessor.java
EOF

    if test "$w" == "DYNAMIC"; then

        cat << EOF >> $fname
 * @build jdk.test.whitebox.WhiteBox
 * @run driver jdk.test.lib.helpers.ClassFileInstaller jdk.test.whitebox.WhiteBox
 * @run junit/othervm/timeout=480 -Dcds.app.tester.workflow=$w -XX:+UnlockDiagnosticVMOptions -XX:+WhiteBoxAPI -Xbootclasspath/a:. $i
 */
EOF
    else
        cat << EOF >> $fname
 * @run junit/othervm/timeout=480 -Dcds.app.tester.workflow=$w $i
 */
EOF

    fi
done

    cat << EOF >> $fname
import org.junit.Test;

public class $i {
    @Test
    public void test() throws Exception {
        JDKMethodHandlesTestRunner.test($i.class.getName());
    }
}
EOF
done
