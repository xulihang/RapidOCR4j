B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private config As JavaObject
	Private rapid As JavaObject
	Private th As Thread
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(detModelPath As String,recModelPath As String,recDictPath As String,clsModelPath As String)
	config.InitializeNewInstance("io.github.hzkitty.entity.OcrConfig",Null)
	config.GetFieldJO("Det").RunMethod("setModelPath",Array(detModelPath))
	config.GetFieldJO("Rec").RunMethod("setRecKeysPath",Array(recDictPath))
	config.GetFieldJO("Rec").RunMethod("setModelPath",Array(recModelPath))
	config.GetFieldJO("Cls").RunMethod("setModelPath",Array(clsModelPath))
	Dim rapidStatic As JavaObject
	rapidStatic.InitializeStatic("io.github.hzkitty.RapidOCR")
	rapid = rapidStatic.RunMethod("create",Array(config))
	th.Initialise("th")
End Sub

private Sub ImageToBytes(Image As B4XBitmap) As Byte()
	Dim out As OutputStream
	out.InitializeToBytesArray(0)
	Image.WriteToStream(out, 100, "JPEG")
	out.Close
	Return out.ToBytesArray
End Sub

Public Sub DetectAsync(path As String,img As B4XBitmap,textDetection As Boolean,rotationDetection As Boolean) As ResumableSub
	Dim regions As List
	regions.Initialize
	Dim map1 As Map
	map1.Initialize
	map1.Put("path",path)
	map1.Put("img",img)
	map1.Put("rotationDetection",rotationDetection)
	map1.Put("textDetection",textDetection)
	map1.Put("regions",regions)
	th.Start(Me,"DetectInner",Array As Map(map1))
	wait for th_Ended(endedOK As Boolean, error As String)
	Log(endedOK)
	Log(error)
	Return regions
End Sub

Public Sub Detect(path As String,img As B4XBitmap,textDetection As Boolean,rotationDetection As Boolean) As List
	Dim regions As List
	regions.Initialize
    Dim map1 As Map
	map1.Initialize
	map1.Put("path",path)	
	map1.Put("img",img)
	map1.Put("rotationDetection",rotationDetection)
	map1.Put("textDetection",textDetection)
	map1.Put("regions",regions)
	Return DetectInner(map1)
End Sub

Private Sub DetectInner(map1 As Map) As List
	Dim regions As List
	Dim path As String 
	Dim img As B4XBitmap 
	Dim rotationDetection As Boolean
	Dim textDetection As Boolean = True
	textDetection = map1.Get("textDetection")
	Dim paramsConfig As JavaObject
	paramsConfig.InitializeNewInstance("io.github.hzkitty.entity.ParamConfig",Null)
	paramsConfig.SetField("useDet",textDetection)
	path = map1.Get("path")
	img = map1.Get("img")
	rotationDetection = map1.Get("rotationDetection")
	regions = map1.Get("regions")
	Dim result As JavaObject
	If img.IsInitialized Then
		result = rapid.RunMethod("run",Array(ImageToBytes(img),paramsConfig))
	Else
		result= rapid.RunMethod("run",Array(path,paramsConfig))
	End If

	If textDetection Then
		Dim recResults As List = result.RunMethod("getRecRes",Null)
		For Each recResult As JavaObject In recResults
			Dim region As Map
			region.Initialize
			Dim pointsArray() As Object = recResult.RunMethod("getDtBoxes",Null)
		
			Dim left,top,width,height As Int
			Dim X1,X2,X3,X4,Y1,Y2,Y3,Y4 As Int
			Dim index As Int
			For Each pointJO As JavaObject In pointsArray
				If index = 0 Then
					X1 = pointJO.GetField("x")
					Y1 = pointJO.GetField("y")
				else if index = 1 Then
					X2 = pointJO.GetField("x")
					Y2 = pointJO.GetField("y")
				else if index = 2 Then
					X3 = pointJO.GetField("x")
					Y3 = pointJO.GetField("y")
				else if index = 3 Then
					X4 = pointJO.GetField("x")
					Y4 = pointJO.GetField("y")
				End If
				index = index + 1
			Next
			Dim minX,maxX,minY,maxY As Int
			minX = -1
			minY = -1
			For Each X As Int In Array(X1,X2,X3,X4)
				If minX = -1 Then
					minX = X
				Else
					minX = Min(minX,X)
				End If
				maxX = Max(maxX,X)
			Next
			For Each Y As Int In Array(Y1,Y2,Y3,Y4)
				If minY = -1 Then
					minY = Y
				Else
					minY = Min(minY,Y)
				End If
				maxY = Max(maxY,Y)
			Next
			If rotationDetection Then
				Dim centerX As Int = minX + (maxX - minX) / 2
				Dim centerY As Int = minY + (maxY - minY) / 2
				Dim K As Double = (Y2-Y1)/(X2-X1)
				Dim degree As Int= ATan(K) * 180 / cPI
				If degree < 0 Then
					degree = degree + 360
				End If
				Dim point1(2) As Int = CalculateRotatedPosition(-degree,centerX,centerY,X1,Y1)
				Dim point2(2) As Int = CalculateRotatedPosition(-degree,centerX,centerY,X2,Y2)
				Dim point3(2) As Int = CalculateRotatedPosition(-degree,centerX,centerY,X3,Y3)
				Dim point4(2) As Int = CalculateRotatedPosition(-degree,centerX,centerY,X4,Y4)
				minX = -1
				minY = -1
				For Each X As Int In Array(point1(0),point2(0),point3(0),point4(0))
					If minX = -1 Then
						minX = X
					Else
						minX = Min(minX,X)
					End If
					maxX = Max(maxX,X)
				Next
				For Each Y As Int In Array(point1(1),point2(1),point3(1),point4(1))
					If minY = -1 Then
						minY = Y
					Else
						minY = Min(minY,Y)
					End If
					maxY = Max(maxY,Y)
				Next
				If degree <> 0 Then
					Dim extra As Map
					extra.Initialize
					extra.Put("degree",degree)
					region.Put("extra",extra)
				End If
			End If
			width = maxX - minX
			height = maxY - minY
			left = minX
			top = minY

			region.Put("text",recResult.RunMethod("getText",Null))
			region.Put("X",left)
			region.Put("Y",top)
			region.Put("width",width)
			region.Put("height",height)
		
			regions.Add(region)
		Next
	Else
		Dim recResults As List = result.RunMethod("getRecRes",Null)
		Dim recResult As JavaObject = recResults.Get(0)
		Dim region As Map
		region.Initialize
		region.Put("text",recResult.RunMethod("getText",Null))
		region.Put("X",0)
		region.Put("Y",0)
		region.Put("width",10)
		region.Put("height",10)
		regions.Add(region)
	End If
	
	Return regions
End Sub

Sub CalculateRotatedPosition(degree As Double,pivotx As Double,pivoty As Double,x As Double,y As Double) As Int()
	Dim rotate As JavaObject
	rotate.InitializeNewInstance("javafx.scene.transform.Rotate",Array(degree,pivotx,pivoty))
	Dim point2dJO As JavaObject = rotate.RunMethod("transform",Array(x,y))
	Dim point(2) As Int
	point(0)=point2dJO.RunMethod("getX",Null)
	point(1)=point2dJO.RunMethod("getY",Null)
	Return point
End Sub


Public Sub GetTextAsync(path As String,img As B4XBitmap,textDetection As Boolean,rotationDetection As Boolean) As ResumableSub
	Dim map1 As Map
	map1.Initialize
	map1.Put("path",path)
	map1.Put("img",img)
	map1.Put("rotationDetection",rotationDetection)
	map1.Put("textDetection",textDetection)
	th.Start(Me,"GetTextInner",Array As Map(map1))
	wait for th_Ended(endedOK As Boolean, error As String)
	Log(endedOK)
	Log(error)
	Return map1.GetDefault("text","")
End Sub

Public Sub GetText(path As String,img As B4XBitmap,textDetection As Boolean,rotationDetection As Boolean) As String
    Dim map1 As Map
	map1.Initialize
	map1.Put("path",path)
	map1.Put("img",img)
	map1.Put("rotationDetection",rotationDetection)
	map1.Put("textDetection",textDetection)
	Return GetTextInner(map1)
End Sub

Private Sub GetTextInner(map1 As Map) As String
	Dim path As String 
	Dim img As B4XBitmap 
	path = map1.Get("path")
	img = map1.Get("img")
    Dim textDetection As Boolean = True
	textDetection = map1.GetDefault("textDetection",textDetection)
	Dim paramsConfig As JavaObject
	paramsConfig.InitializeNewInstance("io.github.hzkitty.entity.ParamConfig",Null)
	paramsConfig.SetField("useDet",textDetection)
	Dim result As JavaObject
	If img.IsInitialized Then
		result = rapid.RunMethod("run",Array(ImageToBytes(img),paramsConfig))
	Else
		result= rapid.RunMethod("run",Array(path,paramsConfig))
	End If
	Log(result)
	Dim text As String = result.RunMethod("getStrRes",Null)
	map1.Put("text",text)
	Return text
End Sub
