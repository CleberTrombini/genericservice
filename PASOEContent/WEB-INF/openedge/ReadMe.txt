<target name="test">
    <ABLUnit>
      <fileset dir="AppServer/tests" includes="**/*.cls" />
      <propath>
        <pathelement path="AppServer/tests" />
        <pathelement path="AppServer" />
      </propath>
    </ABLUnit>
</target>