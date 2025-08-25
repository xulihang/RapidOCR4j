B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private config As JavaObject
	Private ocr As JavaObject
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(detModelPath As String,recModelPath As String,recDictPath As String,clsModelPath As String)
	config.InitializeNewInstance("io.github.hzkitty.entity.OcrConfig",Null)
	config.GetFieldJO("Det").RunMethod("setModelPath",Array(detModelPath))
	config.GetFieldJO("Rec").RunMethod("setRecKeysPath",Array(recDictPath))
	config.GetFieldJO("Rec").RunMethod("setModelPath",Array(recModelPath))
	config.GetFieldJO("Cls").RunMethod("setModelPath",Array(clsModelPath))
	Dim rapid As JavaObject
	rapid.InitializeStatic("io.github.hzkitty.RapidOCR")
	ocr = rapid.RunMethod("create",Array(config))
End Sub

Public Sub Detect(path As String,rotationDetection As Boolean) As List
	Dim result As JavaObject = ocr.RunMethod("run",Array(path))
	Dim recResults As List = result.RunMethod("getRecRes",Null)
	Dim regions As List
	regions.Initialize
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
				region.Put("degree",degree)
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