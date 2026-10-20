<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="23008000">
	<Property Name="NI.LV.All.SaveVersion" Type="Str">23.0</Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="DUT-Test" Type="Folder">
			<Item Name="Init Read Test.vi" Type="VI" URL="../../../../../measurement-plugin-automotive-interface-plugins/src/workflow/dut-sample/DUT-Test/Init Read Test.vi"/>
			<Item Name="Init Write Test.vi" Type="VI" URL="../../../../../measurement-plugin-automotive-interface-plugins/src/workflow/dut-sample/DUT-Test/Init Write Test.vi"/>
			<Item Name="Main Test.vi" Type="VI" URL="../../../../../measurement-plugin-automotive-interface-plugins/src/workflow/dut-sample/DUT-Test/Main Test.vi"/>
			<Item Name="Read Signals.vi" Type="VI" URL="../DUT-Test/Read Signals.vi"/>
			<Item Name="Write Signals.vi" Type="VI" URL="../../../../../measurement-plugin-automotive-interface-plugins/src/workflow/dut-sample/DUT-Test/Write Signals.vi"/>
		</Item>
		<Item Name="DUT Main.vi" Type="VI" URL="../DUT Main.vi"/>
		<Item Name="DUT Sample.lvclass" Type="LVClass" URL="../DUT Sample/DUT Sample.lvclass"/>
		<Item Name="Launch N DUTs.vi" Type="VI" URL="../Launch N DUTs.vi"/>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
